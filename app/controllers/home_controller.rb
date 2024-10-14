class HomeController < ApplicationController
  def register
    # Renders the registration form
  end

  def create
    firebase_service = FirebaseService.new
    user_data = {
      id: SecureRandom.uuid,
      username: params[:username],
      sodienthoai: params[:sodienthoai],
      email: params[:email],
      password: params[:password],
      dia_chi: params[:dia_chi] || "123 Main St",
      anh_dai_dien: params[:anh_dai_dien] || "link_to_image",
      key_ma_hoa: "encryptionKey123",
      ngay_tao: Time.now.utc.iso8601,
      trang_thai: true,
      ngay_cap_nhat: Time.now.utc.iso8601
    }

    begin
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
end
