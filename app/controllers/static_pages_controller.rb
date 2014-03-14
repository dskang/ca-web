class StaticPagesController < ApplicationController
  def home
    @schools = %w(princeton harvard yale brown upenn columbia dartmouth cornell)
    @number_of_rows = 2
  end

  def about
  end

  def how_it_works
  end
end
