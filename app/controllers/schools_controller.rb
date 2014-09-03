class SchoolsController < ApplicationController
  def countdown
    @school = get_school_or_redirect
  end

  def share
    @school = get_school_or_redirect
  end

  private

  def get_school_or_redirect
    school = School.find_by(name: params[:school].downcase)
    if school.nil?
      redirect_to :root
    else
      school
    end
  end
end
