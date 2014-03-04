class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @epuser
      flash[:success] = "欢迎来到时间竞拍网站！"
      redirect_to @epuser
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  #修改密码
  def update
    @user = User.find(params[:id])
    logger.debug "#{user_params[:oldpassword]}"
    if @user && @user.authenticate(user_params[:oldpassword])
      logger.debug "success"
      if @user.update_attributes(password: user_params[:password], password_confirmation: user_params[:password_confirmation])
          flash[:success] = "成功修改密码"
          redirect_to @user
      else
        render 'edit'
      end      
    else
      logger.debug "error"
      flash[:error] = "原始密码不正确，请重新修改"
      redirect_to edit_user_path(current_user)
    end    
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :level, :oldpassword, :userpost, :email, :phone, :status, :workunits,
                                   :truename, :password_confirmation)
  end
end
