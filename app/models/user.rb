class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  belongs_to :school

  before_validation :set_school_from_email

  validate :current_student
  validates :email, :school, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, if: :password_required?

  EMAIL_REGEX = /\A[\w+\-.]+@((?<subdomains>.+)\.)*(?<school>.+)\.edu\z/i
  ALUMNI_SUBDOMAINS = %w(alumni cca post aya)

  def set_school_from_email
    match = EMAIL_REGEX.match(email)
    if match
      school = School.find_by(name: match[:school])
      if school
        self.school = school
      else
        errors.add(:school, "must be in the Ivy League")
      end
    else
      errors.add(:email, "must be an .edu email address")
    end
  end

  def current_student
    match = EMAIL_REGEX.match(email)
    if match
      subdomains = match[:subdomains]
      if subdomains
        ALUMNI_SUBDOMAINS.each do |alumni_subdomain|
          if subdomains.include? alumni_subdomain
            errors.add(:email, "can't be an alumni email address")
          end
        end
      end
    end
  end

  protected

  # Passwords are only required for new records because saved records
  # don't have a password field
  def password_required?
    !persisted?
  end

end
