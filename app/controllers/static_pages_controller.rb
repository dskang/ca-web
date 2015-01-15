class StaticPagesController < ApplicationController
  def home
  end

  def about
  end

  def chat
    render layout: false
  end
end
