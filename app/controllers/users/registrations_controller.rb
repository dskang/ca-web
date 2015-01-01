class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @school = School.find_by(name: params[:school])
    super
  end

  def create
    super do |user|
      @school = user.school
    end
  end
end
