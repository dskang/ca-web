class School < ActiveRecord::Base
  has_many :countdown_users

  def self.proper_name(school)
    case school
    when "upenn"
      "University of Pennsylvania"
    else 
      school.titleize
    end
  end

  def self.unlocked_threshold
    500
  end

  def self.is_allowed?(school)
    allowed_names = [/princeton/i, /harvard/i, /yale/i, /brown/i, /upenn/i, /columbia/i, /dartmouth/i, /cornell/i]
    if school.nil?
      return false
    elsif allowed_names.any? {|allowed_school| allowed_school =~ school}
      return true
    else
      return false
    end
  end

  def is_unlocked?
    if self.signups >= School.unlocked_threshold
      true
    else
      false
    end
  end
end
