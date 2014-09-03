class School < ActiveRecord::Base
  has_many :countdown_users
  has_many :users

  validate :name, presence: true, uniqueness: true

  UNLOCK_THRESHOLD = 500

  def percent_signed_up
    signups.to_f / UNLOCK_THRESHOLD * 100
  end

  def proper_name
    case name
    when "upenn"
      "Penn"
    else 
      name.titleize
    end
  end

  def unlocked?
    signups >= UNLOCK_THRESHOLD
  end

  # use the name as the slug
  # https://gist.github.com/cdmwebs/1209732
  def to_param
    name.parameterize
  end
end
