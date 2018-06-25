module SessionTestHelper
  def is_logged_in?
    session[:user_id].present?
  end

  def log_in(user)
    session[:user_id] = user.id
  end
end
