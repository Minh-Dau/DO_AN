require 'bcrypt'

class SessionsController < ApplicationController
  def login
  end
  def create
    firebase = FirebaseService.new
    user = firebase.find_user_by_email(params[:email])

    if user
      user_data = user[:data]

      if params[:password] == user_data["password"]
        session[:user_id] = user_data["id"]
        render json: { success: true, message: 'Đăng nhập thành công.' }
      else
        render json: { success: false, message: 'Mật khẩu không chính xác.' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: 'Email không tồn tại.' }, status: :unprocessable_entity
    end
  end

  def show
    firebase = FirebaseService.new
  
    # Lấy thông tin người dùng từ session
    user_id = session[:user_id]
    @user = firebase.find_user_by_id(user_id)
  
    unless @user
      redirect_to login_path, alert: "Bạn cần đăng nhập để truy cập trang này."
    end
  end
  def destroy
    Rails.logger.debug("Logging out user ID: #{session[:user_id]}") # Debugging log
    session[:user_id] = nil
    redirect_to login_path, notice: 'Đã đăng xuất.'
  end
end

