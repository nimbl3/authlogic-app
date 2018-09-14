class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    # NOTE:
    # Authlogic deprecated the use of ActionController::Parameters and use the plain hash instead
    #
    # - https://github.com/binarylogic/authlogic/issues/512
    # - https://github.com/binarylogic/authlogic/pull/558
    # - https://github.com/binarylogic/authlogic/pull/577
    @user_session = UserSession.new(user_session_params.to_h)

    if @user_session.save
      redirect_to root_path, notice: 'You\'re successfully logged in'
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_path, notice: 'You\'re successfully logged out'
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end
