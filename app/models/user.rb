class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  devise :confirmable
  belongs_to :school

  validates :email, presence: true, length: { maximum: 50 }
  validates :school_name, presence: true
  validate :email_must_belong_to_school

  def email_must_belong_to_school
    unless school.nil?
      pattern = /\A[\w+\-.]+@#{school.name}.edu\z/i
      if pattern.match(email).nil?
        errors.add(:email, "email must be a #{school.name}.edu address")
      end
    end
  end
end
