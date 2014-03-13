class SchoolsController < ApplicationController
  def countdown
    @school = School.find_by(name: params[:school].downcase)
    if @school.nil?
      redirect_to :root
    end
  end
end
