class Admin::UsersController < ApplicationController
  include AdminAuthorization

  before_action :set_user, only: [ :show, :make_admin, :remove_admin, :destroy ]

  def index
    @users = User.includes(:sessions, :file_transfer_activities)
                 .recent
                 .page(params[:page])
                 .per(25)

    # Filter by admin status if requested
    @users = @users.admins if params[:filter] == "admins"
    @users = @users.regular_users if params[:filter] == "regular"

    # Search by email if query provided
    if params[:query].present?
      @users = @users.where("email_address LIKE ?", "%#{params[:query]}%")
    end
  end

  def show
    @recent_sessions = @user.sessions.order(created_at: :desc).limit(10)
    @recent_activities = @user.file_transfer_activities.order(created_at: :desc).limit(20)
  end

  def make_admin
    if @user.update(admin: true)
      redirect_to admin_user_path(@user), notice: "#{@user.email_address} is now an admin."
    else
      redirect_to admin_user_path(@user), alert: "Failed to make user admin."
    end
  end

  def remove_admin
    # Prevent removing yourself as admin
    if @user.id == Current.user.id
      redirect_to admin_user_path(@user), alert: "You cannot remove your own admin privileges."
      return
    end

    # Protect primary admin account
    if @user.primary_admin?
      redirect_to admin_user_path(@user), alert: "The primary admin account cannot be demoted."
      return
    end

    if @user.update(admin: false)
      redirect_to admin_user_path(@user), notice: "Admin privileges removed from #{@user.email_address}."
    else
      redirect_to admin_user_path(@user), alert: "Failed to remove admin privileges."
    end
  end

  def destroy
    if @user == Current.user
      redirect_to admin_users_path, alert: "You cannot delete your own account."
      return
    end

    # Protect primary admin account from deletion
    if @user.primary_admin?
      redirect_to admin_users_path, alert: "The primary admin account cannot be deleted."
      return
    end

    email = @user.email_address

    if @user.delete_account_and_data!
      # Send confirmation email
      AccountMailer.deletion_confirmation(email).deliver_later
      redirect_to admin_users_path, notice: "User #{email} has been deleted."
    else
      redirect_to admin_users_path, alert: "Failed to delete user."
    end
  rescue StandardError => e
    Rails.logger.error "Admin user deletion failed: #{e.message}"
    redirect_to admin_users_path, alert: "Failed to delete user. Please try again."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
