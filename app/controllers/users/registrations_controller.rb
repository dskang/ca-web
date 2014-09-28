class Users::RegistrationsController < Devise::RegistrationsController
  def new
    @school = School.find_by(name: params[:school])
    super
  end

  def create
    super
  end

  def show
    super
  end
end
