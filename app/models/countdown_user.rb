class CountdownUser < ActiveRecord::Base

  devise :confirmable
  belongs_to :school

  validates :email, presence: true, length: {maximum: 50}
  validate  :domain_is_allowed?

  def get_school_name_from_email
    pattern = /\A[\w+\-.]+@(?<school_name>\w+).edu\z/i
    match = pattern.match(email)
    match.nil? ? match : match[:school_name]
  end

  def domain_is_allowed?
    if School.is_allowed?(get_school_name_from_email)
      return true
    else
      errors.add(:email, "Not a valid Ivy League .edu domain!")
      return false
    end
  end

  def set_school_id!
    name = get_school_name_from_email
    if name.nil?
      self.update(school_id: nil)
    else
      school = School.find_by(name:name)
      if school.nil? and self.domain_is_allowed?
        new_school = School.create(name: self.get_school_name_from_email, signups: 0)
        new_school.save
        self.update(school_id: new_school.id)
      else
        self.update(school_id: school.id)
      end
    end
  end

end
