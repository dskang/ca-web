class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :school

  validates :name, :class_year, :email, :school, presence: true
  validates :class_year, numericality: {
    only_integer: true,
    greater_than_or_equal_to: Time.now.year,
    less_than_or_equal_to: Time.now.year + 4
  }

  validate :email_must_match_school

  def email_must_match_school
    pattern = /\A[\w+\-.]+@(?<school_name>[\w+\-.]+).edu\z/i
    match = pattern.match(email)
    if match.nil?
      errors.add(:email, "invalid email")
    else
      school_name = match["school_name"]
      unless school.name == school_name
        errors.add(:email, "invalid email")
      end
    end
  end


end
