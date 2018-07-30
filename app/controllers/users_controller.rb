class UsersController < ApplicationController
  before_action :set_user

  def show
    unless @user
      redirect_to users_url
    end
  end

  private
    def set_user
      @user = User.find_by(id: params[:id])
    end
end
