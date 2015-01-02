class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  belongs_to :school

  before_validation :set_school_from_email

  validates :email, :school, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, if: :password_required?

  EMAIL_REGEX = /\A[\w+\-.]+@(?<school>\w+)\.edu\z/i

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
      errors.add(:email, "must be of the form id@college.edu")
    end
  end

  # Passwords are only required for new records because saved records
  # don't have a password field
  def password_required?
    !persisted?
  end
end
