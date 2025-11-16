class ProfilesController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    # Prevent OAuth users from updating their profile
    if @user.oauth_user? && params[:user][:password].blank?
      redirect_to profile_path, alert: "Profile information is managed by #{@user.provider.titleize} and cannot be edited here."
      return
    end

    if params[:user][:password].present?
      # Prevent OAuth users from setting passwords
      if @user.oauth_user?
        redirect_to profile_path, alert: "Password management is not available for #{@user.provider.titleize} accounts."
        return
      end

      # Updating password
      if @user.authenticate(params[:user][:current_password])
        if @user.update(password_params)
          redirect_to profile_path, notice: "Password updated successfully."
        else
          render :edit, status: :unprocessable_entity
        end
      else
        @user.errors.add(:current_password, "is incorrect")
        render :edit, status: :unprocessable_entity
      end
    else
      # Updating profile information
      if @user.update(profile_params)
        redirect_to profile_path, notice: "Profile updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    # Store email before deletion for confirmation
    email = @user.email_address

    # Delete account and all associated data
    @user.delete_account_and_data!

    # Send confirmation email
    AccountMailer.deletion_confirmation(email).deliver_later

    # Redirect to landing page with confirmation message
    redirect_to root_path, notice: "Your account has been deleted. A confirmation email has been sent to #{email}."
  rescue StandardError => e
    Rails.logger.error "Account deletion failed: #{e.message}"
    redirect_to profile_path, alert: "Unable to delete account. Please try again or contact support."
  end

  private

  def set_user
    @user = Current.user
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :email_address)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
