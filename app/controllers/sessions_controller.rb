require 'bcrypt'

class SessionsController < ApplicationController
  def login
  end
  def create
    firebase = FirebaseService.new
  
    # Find user by email
    user = firebase.find_user_by_email(params[:email])
  
    if user
      user_data = user[:data]
  
      # Check password
      if params[:password] == user_data["password"]
        # Successful login
        session[:user_id] = user_data["id"]
        redirect_to show_path, notice: 'Đăng nhập thành công!'
      else
        # Incorrect password
        @message = 'Mật khẩu không chính xác.'
        render :login, status: :unprocessable_entity
      end
    else
      # User not found
      @message = 'Email không tồn tại.'
      render :login, status: :unprocessable_entity
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

