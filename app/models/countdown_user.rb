class CountdownUser < ActiveRecord::Base

  devise :confirmable
  belongs_to :school

  validates :email, presence: true, length: {maximum: 50}
  validate  :school_is_allowed

  def get_school_name
    pattern = /\A[\w+\-.]+@(?<school_name>\w+).edu\z/i
    match = pattern.match(email)
    match.nil? ? match : match[:school_name]
  end

  def school_is_allowed
    allowed_domains = [/princeton/i, /harvard/i, /yale/i, /brown/i, /upenn/i, /columbia/i, /dartmouth/i, /cornell/i]
    if get_school_name.nil?
      errors.add(:email, "Not a valid email address!")
    else
      errors.add(:email, "Not a valid .edu domain!") unless allowed_domains.any? {|school| school =~ get_school_name}
    end
  end

  def get_school_id
    name = get_school_name
    if name.nil?
      return nil
    else
      school = School.find_by(name:name.titleize) #FIXME
      if school.nil?
        return nil
      else
        return school.id
      end
    end
  end

end
