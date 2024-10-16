require "firebase"
require "httparty"
require "ostruct"
require 'bcrypt'

class FirebaseService
  def initialize
    config = Rails.application.config_for(:firebase)
    @firebase = Firebase::Client.new(config["database_url"], config["secret_key"])
  end

  def create_user(data)
    path = "nguoidung/#{data[:id]}"
    response = @firebase.set(path, data)
    response
  end

  def get_user(id)
    path = "nguoidung/#{id}"
    response = @firebase.get(path)
    response
  end

  def update_user(id, data)
    path = "nguoidung/#{id}"
    response = @firebase.update(path, data)
    response
  end

  def delete_user(id)
    path = "nguoidung/#{id}"
    response = @firebase.delete(path)
    response
  end
  
  def find_user_by_email(email)
    path = "nguoidung"
    response = @firebase.get(path)

    if response.success?
      users = response.body
      users.each do |id, data|
        return { id: id, data: data } if data["email"] == email
      end
    end
    nil # Trả về nil nếu không tìm thấy người dùng
  end
  def find_user_by_id(user_id)
    path = "nguoidung/#{user_id}"
    response = @firebase.get(path)
  
    Rails.logger.debug("Response for user_id #{user_id}: #{response.inspect}") # Debugging
  
    if response.success?
      return { id: user_id, data: response.body }
    end
    nil
  end
  def destroy
    Rails.logger.debug("Logging out user ID: #{session[:user_id]}")
    session[:user_id] = nil
    redirect_to login_path, notice: 'Đã đăng xuất.'
  end  

  def create_user(data)
    # Băm mật khẩu trước khi lưu
    data[:mat_khau] = BCrypt::Password.create(data[:mat_khau])
    path = "nguoidung/#{data[:id]}"
    response = @firebase.set(path, data)
    response
  end
end
