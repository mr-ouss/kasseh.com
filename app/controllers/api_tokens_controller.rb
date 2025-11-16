# frozen_string_literal: true

class ApiTokensController < ApplicationController
  before_action :require_authentication
  before_action :set_api_token, only: [ :destroy ]

  def index
    @api_tokens = Current.user.api_tokens.order(created_at: :desc)
  end

  def new
    @api_token = Current.user.api_tokens.build
  end

  def create
    @api_token = Current.user.api_tokens.build(api_token_params)

    if @api_token.save
      # Store the plain token in flash to display once
      flash[:api_token] = @api_token.token
      redirect_to api_tokens_path, notice: "✓ API token created successfully. Make sure to copy it now - you won't be able to see it again!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @api_token.destroy
    redirect_to api_tokens_path, notice: "✓ API token revoked successfully."
  end

  private

  def set_api_token
    @api_token = Current.user.api_tokens.find(params[:id])
  end

  def api_token_params
    params.require(:api_token).permit(:name, :expires_at)
  end
end
