class SessionsController < ApplicationController
  before_action :logged_in?, only: [:destroy]

  def new
    if session[:user_id].present?
      redirect_to events_path
    end
    @user = User.new
  end

  def create
    @user = User.find_or_create_by(user_params)

    if @user.valid?
      login_and_redirect @user, 'ログインに成功しました。'
    else
      redirect_back(fallback_location: root_path, notice: '無効なアカウントです。')
    end
  end

  def destroy
    logout_and_redirect
  end

  private

    def user_params
      { name: request.env['omniauth.auth']['info']['name'], email: request.env['omniauth.auth']['info']['email'] }
    end

    def request_from
      request.env['omniauth.params']['request_from']
    end

    def login_and_redirect(user, notice)
      session[:user_id] = user.id
      redirect_to events_url, notice: notice
    end

    def logout_and_redirect
      session[:user_id] = nil
      redirect_to root_url, notice: 'ログアウトしました。'
    end
end
