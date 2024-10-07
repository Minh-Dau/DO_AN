require "firebase"
require "securerandom"

class HomeController < ApplicationController
  def register
    # Renders the registration form
  end

  def create
    firebase_service = FirebaseService.new

    # Gather data from the registration form
    user_data = {
      id: SecureRandom.uuid,  # Generate a unique ID
      username: params[:username],
      sodienthoai: params[:sodienthoai],
      email: params[:email],
      password: params[:password],
      dia_chi: params[:dia_chi] || "123 Main St",  # Optional address
      anh_dai_dien: params[:anh_dai_dien] || "link_to_image",  # Optional avatar
      key_ma_hoa: "encryptionKey123",
      ngay_tao: Time.now.utc.iso8601,
      trang_thai: true,
      ngay_cap_nhat: Time.now.utc.iso8601
    }

    begin
      # Call FirebaseService to save the user data
      result = firebase_service.create_user(user_data)

      if result.success?
        redirect_to login_path, notice: "Đăng ký thành công!"
      else
        @message = "Đăng ký không thành công. Vui lòng thử lại."
        render :register
      end
    rescue => e
      @message = "Có lỗi xảy ra: #{e.message}"
      render :register
    end
  end

  def show
    firebase_service = FirebaseService.new
    user_id = params[:id]

    # Validate user_id
    if user_id.blank?
      render json: { message: "User ID không hợp lệ" }, status: :unprocessable_entity
      return
    end

    begin
      user = firebase_service.get_user(user_id)

      if user.nil? || user.body.nil?
        render json: { message: "Người dùng không tồn tại" }, status: :not_found
      else
        render json: user.body, status: :ok
      end
    rescue => e
      render json: { message: "Có lỗi xảy ra: #{e.message}" }, status: :internal_server_error
    end
  end

  def login
    # Đăng nhập
  end

  def login_process
    firebase_service = FirebaseService.new

    email = params[:username]
    password = params[:password]

    begin
      # Kiểm tra người dùng với FirebaseService
      user = firebase_service.find_user_by_email(email)

      if user.nil? || user.body.nil?
        @message = "Người dùng không tồn tại"
        render :login
      elsif user.body['password'] == password
        # Lưu thông tin người dùng vào session khi đăng nhập thành công
        session[:user_id] = user.body['id']
        redirect_to root_path, notice: "Đăng nhập thành công!"
      else
        @message = "Sai mật khẩu. Vui lòng thử lại."
        render :login
      end
    rescue => e
      @message = "Có lỗi xảy ra: #{e.message}"
      render :login
    end
  end


  def home
    # Implement home/dashboard logic
  end
end
