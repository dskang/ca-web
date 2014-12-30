class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  belongs_to :school

  validate :class_year_must_be_valid
  validate :email_must_match_unlock_page
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true

  def class_year_must_be_valid
    current_year = Time.now.year
    unless class_year >= current_year and class_year <= current_year + 4
      errors.add(:class_year, "invalid class year")
    end
  end

  def email_must_match_unlock_page
    pattern = /\A[\w+\-.]+@(?<school_name>[\w+\-.]+).edu\z/i
    if pattern.match(email).nil?
      errors.add(:email, "invalid email")
    else
      school_name = pattern.match(email)["school_name"]
      unless school.name == school_name
        errors.add(:email, "invalid email")
      end
    end
  end


end
