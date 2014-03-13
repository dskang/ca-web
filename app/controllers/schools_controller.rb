class SchoolsController < ApplicationController

  def landing
    @url_name = params[:school_name].downcase
    @school = School.find_by(name:@url_name)
    unless @school.nil?
      @school_unlocked = @school.is_unlocked?
      @school_signups_completed = @school.signups
      @school_signups_remaining = School.unlocked_threshold - @school.signups
      @school_name = School.proper_name(@school.name)
    end
  end

end
