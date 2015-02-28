class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: :chat

  def home
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
end
