# frozen_string_literal: true

class LegalController < ApplicationController
  skip_before_action :require_authentication

  def privacy
    render layout: "application"
  end

  def terms
    render layout: "application"
  end

  def support
    render layout: "application"
  end
end
