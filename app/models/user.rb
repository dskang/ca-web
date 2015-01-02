class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :school

  before_validation :set_school_from_email

  validates :email, :school, presence: true

  EMAIL_REGEX = /\A[\w+\-.]+@(?<school>\w+)\.edu\z/i

  def set_school_from_email
    match = EMAIL_REGEX.match(email)
    if match
      school = School.find_by(name: match[:school])
      if school
        self.school = school
      else
        errors.add(:school, "invalid school")
      end
    else
      errors.add(:email, "invalid email")
    end
  end
end
