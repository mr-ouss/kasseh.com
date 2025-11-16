class Admin::DashboardController < ApplicationController
  include AdminAuthorization

  def index
    # User growth data - last 12 months
    @user_growth_data = calculate_user_growth

    # Subscription plan distribution
    @subscription_data = calculate_subscription_distribution

    # Monthly recurring revenue - last 12 months
    @mrr_data = calculate_mrr

    # Quick stats
    @total_users = User.count
    @new_users_this_month = User.where("created_at >= ?", Time.current.beginning_of_month).count
    @active_subscriptions = User.where.not(subscription_plan: "free")
                                 .where(subscription_status: "active")
                                 .count
    @current_mrr = calculate_current_mrr
  end

  private

  def calculate_user_growth
    months = 12.downto(0).map do |i|
      date = i.months.ago.beginning_of_month
      {
        month: date.strftime("%b %Y"),
        new_users: User.where(created_at: date..date.end_of_month).count,
        total_users: User.where("created_at <= ?", date.end_of_month).count
      }
    end
    months
  end

  def calculate_subscription_distribution
    User.group(:subscription_plan).count
  end

  def calculate_mrr
    # Monthly pricing for each plan
    plan_prices = {
      "individual_monthly" => 9.0,
      "individual_yearly" => 7.5,  # $90/year = $7.50/month
      "professional_monthly" => 29.0,
      "professional_yearly" => 24.17  # $290/year = $24.17/month
    }

    months = 12.downto(0).map do |i|
      date = i.months.ago.beginning_of_month
      mrr = 0

      # Calculate MRR for each plan/period combination
      User.where(subscription_status: "active")
          .where("created_at <= ?", date.end_of_month)
          .group(:subscription_plan, :subscription_period)
          .count
          .each do |(plan, period), count|
            next if plan == "free"
            key = "#{plan}_#{period}"
            mrr += (plan_prices[key] || 0) * count
          end

      {
        month: date.strftime("%b %Y"),
        mrr: mrr.round(2)
      }
    end
    months
  end

  def calculate_current_mrr
    plan_prices = {
      "individual" => { "monthly" => 9.0, "yearly" => 7.5 },
      "professional" => { "monthly" => 29.0, "yearly" => 24.17 }
    }

    mrr = 0
    User.where(subscription_status: "active")
        .where.not(subscription_plan: "free")
        .group(:subscription_plan, :subscription_period)
        .count
        .each do |(plan, period), count|
          mrr += (plan_prices.dig(plan, period) || 0) * count
        end

    mrr.round(2)
  end
end
