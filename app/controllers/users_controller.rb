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
    email = signup_params[:email]
    password = signup_params[:password]

    # Make sure to replace 'AIzaSyALnLIj3Hq6gt3ryaiysfIjHMxkbYQS_7Q' with your actual Firebase API key
    uri = URI('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyALnLIj3Hq6gt3ryaiysfIjHMxkbYQS_7Q') 

    # Send the signup request to Firebase
    res = Net::HTTP.post_form(uri, 'email' => email, 'password' => password)

    data = JSON.parse(res.body)

    if res.is_a?(Net::HTTPSuccess)
      session[:user_id] = data['localId'] # Store user ID in session
      redirect_to controller: 'home', action: 'home', notice: 'Signup successful!'
    else
      flash[:error] = data['error']['message'] || 'Signup failed. Please try again.' # Handle errors
      render :new # Render the signup form again on failure
    end
  end

  
  def login
    email = params[:email]
    password = params[:password]
  
    uri = URI('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyALnLIj3Hq6gt3ryaiysfIjHMxkbYQS_7Q')
  
    res = Net::HTTP.post_form(uri, 'email' => email, 'password' => password)
  
    data = JSON.parse(res.body)
  
    if res.is_a?(Net::HTTPSuccess)
      session[:user_id] = data['localId']
      redirect_to action: 'home'  # Change to the action name
    else
      flash[:error] = data['error']['message'] || "Login failed. Please try again."
      redirect_to action: 'dangnhap'  # Change to the action name
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
