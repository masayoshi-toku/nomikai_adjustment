class UsersController < ApplicationController
  VALID_DOMAIN = 'mwed.co.jp'
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if User.find_by(email: user_params[:email])
      redirect_to new_user_url, notice: 'アカウントは既に作成されています。'
    elsif domain_check
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to @user, notice: 'ユーザー作成に成功しました。'
      else
        redirect_to new_user_url, notice: 'ユーザー作成に失敗しました。'
      end
    else
      redirect_to new_user_url, notice: 'このアカウントは無効なアカウントです。'
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def current_user
      @user = User.find(session[:user_id])
    end

    def user_params
      { name: request.env['omniauth.auth']['info']['name'], email: request.env['omniauth.auth']['info']['email'] }
    end

    def domain_check
      request.env['omniauth.auth']['extra']['raw_info']['hd'] == VALID_DOMAIN
    end
end
