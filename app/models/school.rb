class School < ActiveRecord::Base
  has_many :countdown_users
  has_many :users

  validate :name, presence: true

  UNLOCK_THRESHOLD = 500

  def proper_name
    case name
    when "upenn"
      "University of Pennsylvania"
    else 
      name.titleize
    end
  end

  def unlocked?
    signups >= UNLOCK_THRESHOLD
  end
end
