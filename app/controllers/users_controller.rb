class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:index]

  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = I18n.t('users.create.success')
      redirect_to user_path(@user)
    else
      flash[:error] = I18n.t('users.create.failure')
      render action: 'edit'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = I18n.t('users.update.success')
      redirect_to user_path(@user)
    else
      # return to the 'new' form
      flash[:error] = I18n.t('users.update.failure')
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:notice] = I18n.t('users.destroy.success')
    redirect_to :users
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_users
      @users = User.all.alphabetical
      @num_records = @users.count
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
