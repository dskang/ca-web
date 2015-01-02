class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :school

  before_validation :add_school_to_user_from_email

  validates :email, :school, presence: true
  validates :class_year, numericality: {
    only_integer: true,
    greater_than_or_equal_to: Time.now.year,
    less_than_or_equal_to: Time.now.year + 4
  }
  validate :email_must_belong_to_school_in_database

  def add_school_to_user_from_email
    pattern = /\A[\w+\-.]+@(?<school>.+).edu\z/i
    match = pattern.match(user.email)
    school = School.find_by(name: match[:school])
    unless match.nil? or school.nil?
      user.school = school
    end
  end

  def email_must_belong_to_school_in_database
    pattern = /\A[\w+\-.]+@(?<school>.+).edu\z/i
    match = pattern.match(email)
    if match.nil? or School.find_by(name: match[:school]).nil?
      errors.add(:email, "invalid edu email")
    end
  end

end
