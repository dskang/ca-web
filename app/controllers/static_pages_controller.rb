class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: :chat

  def home
    if is_mobile_user?
      flash.now[:notice] = "Please use a desktop browser for the best experience."
    end
  end

  def about
  end

  def terms
  end

  def privacy
  end

  def chat
    if current_user.confirmed?
      session[:email] = current_user.email
      render layout: false
    elsif
      redirect_to root_url, alert: "Please confirm your account."
    end
  end

  protected

  def is_mobile_user?
    request.user_agent =~ /(iPad|iPhone|Android|Windows Phone|Blackberry|Amazon|Kindle)/i
  end

end
