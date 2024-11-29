class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def follow
      user = User.find(params[:id])
      current_user.follow(user)
      redirect_to user_profile_path(user), notice: 'You are now following this user.'
    end
  
    def unfollow
      user = User.find(params[:id])
      current_user.unfollow(user)
      redirect_to user_profile_path(user), notice: 'You have unfollowed this user.'
    end
  
    def show
      @user = User.find(params[:id]) # แสดงโปรไฟล์ผู้ใช้
    end
  end