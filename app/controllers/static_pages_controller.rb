class StaticPagesController < ApplicationController
  def home
    @resource = User.new
    @resource_name = :user
  end

  def chat
    render layout: false
  end
end
