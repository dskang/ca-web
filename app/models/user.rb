class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  belongs_to :school

  before_validation :set_school_from_email

  validates :email, :school, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, if: :password_required?

  EMAIL_REGEX = /\A[\w+\-.]+@((?<subdomain>.+)\.)*(?<school>.+)\.edu\z/i
  ALUMNI_SUBDOMAINS = %w(alumni cca post aya)

  def set_school_from_email
    match = EMAIL_REGEX.match(email)
    subdomain = match[:subdomain]
    school_name = match[:school]
    if match
      if subdomain
        ALUMNI_SUBDOMAINS.each do |alumni_subdomain|
          if subdomain.include? alumni_subdomain
            errors.add(:email, "must not be an alumni email address")
          end
        end
      end
      school = School.find_by(name: school_name)
      if school
        self.school = school
      else
        errors.add(:school, "must be in the Ivy League")
      end
    else
      errors.add(:email, "must be an .edu email address")
    end
  end

  protected

  # Passwords are only required for new records because saved records
  # don't have a password field
  def password_required?
    !persisted?
  end

end
