class CountdownUser < ActiveRecord::Base

  devise :confirmable
  belongs_to :school

  validates :email, presence: true, length: {maximum: 50}
  validate  :domain_is_allowed?

  def self.get_school_name_from(email)
    pattern = /\A[\w+\-.]+@(?<school_name>\w+).edu\z/i
    match = pattern.match(email)
    match[:school_name] unless match.nil?
  end

  def domain_is_allowed?
    if School.is_allowed?(CountdownUser.get_school_name_from(self.email))
      return true
    else
      errors.add(:email, "Not a valid Ivy League .edu domain!")
      return false
    end
  end

  def set_school_id!
    name = CountdownUser.get_school_name_from(self.email)
    if name.nil?
      self.update(school_id: nil)
    else
      school = School.find_by(name:name)
      if school.nil? and self.domain_is_allowed?
        new_school = School.create(name: CountdownUser.get_school_name_from(self.email), signups: 0)
        new_school.save
        self.update(school_id: new_school.id)
      else
        self.update(school_id: school.id)
      end
    end
  end

end
