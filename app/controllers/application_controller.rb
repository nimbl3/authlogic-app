class ApplicationController < ActionController::Base
  helper_method :current_user_session, :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  # NOTE:
  # Because Authlogic introduces its own methods for storing user sessions,
  # the CSRF (Cross Site Request Forgery) protection that is built into Rails will not work out of the box.
  def handle_unverified_request
    # raise an exception
    # raise ActionController::InvalidAuthenticityToken
    # or destroy session, redirect
    if current_user_session
      current_user_session.destroy
    end
    redirect_to root_url
  end
end
