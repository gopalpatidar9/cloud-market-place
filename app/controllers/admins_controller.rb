class AdminsController < ApplicationController
  before_action :authenticate_user!
  # before_action :find_user, only: [:destroy]

  def user_list
    @users = User.all
  end

  def show_all_users
    @users = User.all
  end

  def show_user
    @user = User.find_by(id: params[:id])
    if @user
      @user
    else
      redirect_to admins_path, alert: "user not found"
    end
  end

  def contect_list
    @contects = User.joins(:contects).distinct
  end

  def message
    @user = User.find_by(id: params[:id])
    if @user
      @messages = @user.contects
    else
      redirect_to admins_path, alert: "User not found"
    end
  end

  def user_remove
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admins_user_list_path, notice: 'User was successfully deleted.'
    else
      redirect_to admins_user_list_path, alert: 'User could not be deleted.'
    end
  end

  private

  def user_parmas
    68
  end

end
