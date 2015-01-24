class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: :chat

  def home
  end

  def about
  end

  def chat
    session[:email] = current_user.email
    render layout: false
  end
end
