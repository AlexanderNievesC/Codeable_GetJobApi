class SessionsController < ApplicationController
  skip_before_action :authorize, only: :create
  skip_before_action :verify_authenticity_token, :only => [:create,:inquire_enterprise]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      user.regenerate_token
      render json: user
    else
      respond_unauthorized('Incorrect email or password')
    end
  end

  def destroy
    current_user.invalidate_token
    head :ok
  end

end
