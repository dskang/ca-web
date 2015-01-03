class StaticPagesController < ApplicationController
  def home
  end

  def chat
    render layout: false
  end
end
