class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: :chat

  def home
  end

  def about
  end

  def chat
    render layout: false
  end
end
