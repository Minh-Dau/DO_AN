require "firebase"

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
end
