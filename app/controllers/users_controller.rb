class UsersController < ApplicationController 
  def index
    # Check if user is already logged in
    if session[:user_id]
      redirect_to action: 'home' # Redirect to homepage if already logged in
    else
      render :new # Render the signup form if not logged in
    end
  end

  # For handling signup request
  def signup
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{Rails.application.credentials.firebase_api_key}")

    response = Net::HTTP.post_form(uri, "email": @email, "password": @password)
    data = JSON.parse(response.body)
    session[:user_id] = data['localId']
    session[:data] = data

    redirect_to home_path, notice: 'Signed up successfully!' if response.is_a?(Net::HTTPSuccess)
  end

  def home
    @todos = @todos_service.all
  end

  def login
    uri = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{Rails.application.credentials.firebase_api_key}")

    response = Net::HTTP.post_form(uri, "email": @email, "password": @password)
    data = JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      session[:user_id] = data['localId']
      session[:data] = data
      redirect_to home_path, notice: 'Logged in successfully!'
    end
  end
  def home
    # Any logic needed for the home page
    render 'tranghome'  # Assuming you have a view file named tranghome.html.erb
  end
  
  
  private

  # Strong parameters for signup
  def signup_params
    params.require(:user).permit(:email, :password)
  end
end
