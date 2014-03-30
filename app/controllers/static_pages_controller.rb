class StaticPagesController < ApplicationController
  def home
    @schools = School.all()
    @unlock_threshold = School::UNLOCK_THRESHOLD
  end

  def about
  end

  def how_it_works
  end
end
