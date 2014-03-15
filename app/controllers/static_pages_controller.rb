class StaticPagesController < ApplicationController
  def home
    @schools = %w(princeton harvard yale brown upenn columbia dartmouth cornell)
  end

  def about
  end

  def how_it_works
  end
end
