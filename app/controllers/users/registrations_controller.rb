class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super do |user|
      pattern = /\A[\w+\-.]+@(?<school>.+).edu\z/i
      match = pattern.match(user.email)
      school = School.find_by(name: match[:school])
      unless match.nil? or school.nil?
        user.school = school
      end
    end
  end

  def create
    super
  end
end
