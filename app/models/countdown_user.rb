class CountdownUser < ActiveRecord::Base

  devise :confirmable
  belongs_to :school

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(brown|harvard|yale|princeton|columbia|dartmouth|cornell|upenn).edu\z/
  validates :email, presence: true, length: {maximum: 50}, format: { with: VALID_EMAIL_REGEX}

end
