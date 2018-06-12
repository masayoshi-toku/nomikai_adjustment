class GoogleOmniauthsController < ApplicationController
  def new
    @user = User.find_or_new_from(user_params)

    if request_from == 'login' && @user.persisted?
      login_and_redirect(@user, 'ログインしました。')
    elsif request_from == 'sign_up' && @user.new_record? && @user.save
      login_and_redirect(@user, 'ユーザー作成に成功しました。')
    else
      redirect_back(fallback_location: root_path, notice: '無効なアカウントです。')
    end
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
      redirect_to user, notice: notice
    end
end
