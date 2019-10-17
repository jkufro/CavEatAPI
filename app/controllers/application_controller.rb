class ApplicationController < ActionController::Base
  before_action :authentication_required!

  private
    # Helper method to set the user who is currently logged in.
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    # https://blog.eq8.eu/article/simple-ralis-authentication-for-one-user.html
    ApplicationNotAuthenticated = Class.new(StandardError)

    rescue_from ApplicationNotAuthenticated do
      respond_to do |format|
        format.json { render json: { errors: [message: "401 Not Authorized"] }, status: 401 }
        format.html do
          flash[:notice] = I18n.t('sessions.not_authorized')
          redirect_to new_session_path
        end
        format.any { head 401 }
      end
    end

    def authentication_required!
      session[:user_id] || raise(ApplicationNotAuthenticated)
    end
end
