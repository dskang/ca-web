class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :school

  validates :email, :school, presence: true
  validates :class_year, numericality: {
    only_integer: true,
    greater_than_or_equal_to: Time.now.year,
    less_than_or_equal_to: Time.now.year + 4
  }
  validate :email_must_be_valid

  def email_must_be_valid
    pattern = /\A[\w+\-.]+@(?<school>.+).edu\z/i
    match = pattern.match(email)
    if match.nil? or School.find_by(name: match[:school]).nil?
      errors.add(:email, "invalid edu email")
    end
  end

end
