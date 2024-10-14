require 'bcrypt'

class SessionsController < ApplicationController
  def create
    firebase = FirebaseService.new

    # Tìm người dùng theo email (hoặc bạn có thể dùng 'tai_khoan')
    user = firebase.find_user_by_email(params[:email])

    if user
      user_data = user[:data]

      # Đăng nhập thành công, lưu thông tin vào session
      session[:user_id] = user_data["id"]
      redirect_to show_path, notice: 'Đăng nhập thành công!'
    else
      # Thông báo lỗi nếu không tìm thấy người dùng
      flash.now[:alert] = 'Email không tồn tại.'
      render :new
    end
  end
  def destroy
    # Xóa session khi đăng xuất
    session[:user_id] = nil
    redirect_to login_path, notice: 'Đã đăng xuất.'
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
  
  
end

