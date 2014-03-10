class CountdownUser < ActiveRecord::Base

  devise :confirmable
  belongs_to :school

  validates :email, presence: true, length: {maximum: 50}
  validate  :school_is_allowed?

  def get_school_name
    pattern = /\A[\w+\-.]+@(?<school_name>\w+).edu\z/i
    match = pattern.match(email)
    match.nil? ? match : match[:school_name]
  end

  def school_is_allowed?
    allowed_domains = [/princeton/i, /harvard/i, /yale/i, /brown/i, /upenn/i, /columbia/i, /dartmouth/i, /cornell/i]
    if get_school_name.nil?
      errors.add(:email, "Not a valid email address!")
      return false
    elsif allowed_domains.any? {|school| school =~ get_school_name}
      return true
    else
      errors.add(:email, "Not a valid .edu domain!")
      return false
    end
  end

  def set_school_id!
    name = get_school_name
    if name.nil?
      self.update(school_id: nil)
    else
      school = School.find_by(name:name)
      if school.nil? and self.school_is_allowed?
        new_school = School.create(name: self.get_school_name, signups: 0)
        new_school.save
        self.update(school_id: new_school.id)
      else
        self.update(school_id: school.id)
      end
    end
  end

end
