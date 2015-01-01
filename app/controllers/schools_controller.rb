class SchoolsController < ApplicationController
  def share
    @school = get_school_or_redirect

    remaining_signups = School::UNLOCK_THRESHOLD - @school.signups
    twitter_params = {}
    twitter_params[:url] = "http://campusanonymous.com"
    twitter_params[:text] = "We need #{remaining_signups} more signups to bring Campus Anonymous to #{@school.proper_name}!"
    @twitter_params = twitter_params.to_query
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
