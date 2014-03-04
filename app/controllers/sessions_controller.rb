class SessionsController < ApplicationController
  
  def new   
  end
  
  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      flash[:success] = "#{user.name} 登录成功!"
      redirect_back_or user
    else
      flash[:error] = '用户名或者密码不正确'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
end
