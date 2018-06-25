class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.all
  end

  def show
    unless @user
      redirect_to users_url
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'ユーザーを削除しました。'
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end
end
