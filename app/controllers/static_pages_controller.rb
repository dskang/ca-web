class StaticPagesController < ApplicationController
  def home
    @schools = School.order(signups: :desc)
  end

  def about
  end

  def how_it_works
  end
end
