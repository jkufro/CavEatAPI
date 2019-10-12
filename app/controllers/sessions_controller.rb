class SessionsController < ApplicationController
  # Controller method to create a new instance of the SessionsController
  def new
    @username = ''
  end

  # Controller method to create a new session.
  def create
    @username = params[:username]
    user = User.authenticate(@username, params[:password])
    if user
      session[:user_id] = user.id
      flash[:notice] = I18n.t('sessions.create.success')
      redirect_to :foods
    else
      flash[:alert] = I18n.t('sessions.create.failure')
      render "new"
    end
  end

  # Controller method to destroy a session.
  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: I18n.t('sessions.destroy.success')
  end
end
