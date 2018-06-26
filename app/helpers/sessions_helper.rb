module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    unless current_user.present?
      redirect_to root_path, notice: 'ログインしてください。'
    end
  end
end
