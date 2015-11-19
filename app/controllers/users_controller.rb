class UsersController < ApplicationController

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    # @user.password=(params[:user][:password])
    if @user.save
      login_user!
    else
      # debugger
      flash.now[:notice] = @user.errors.full_messages
      render :new
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
