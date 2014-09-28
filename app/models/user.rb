class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

  belongs_to :school

  validate :email_must_belong_to_school_in_database
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true

  def email_must_belong_to_school_in_database
    pattern = /\A[\w+\-.]+@(?<school_name>[\w+\-.]+).edu\z/i
    p pattern.match(email)
    if pattern.match(email).nil?
      errors.add(:email, "email must be a valid Ivy League email address")
    else
      school_name = pattern.match(email)["school_name"]
      unless School.find_by name: school_name
        errors.add(:email, "email must be a valid Ivy League email address")
      end
    end
  end


end
