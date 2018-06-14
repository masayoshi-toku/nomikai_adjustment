module SessionHelper
  def is_logged_in?
    session[:user_id].present?
  end
end
