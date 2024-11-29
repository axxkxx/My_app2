class PagesController < ApplicationController
    before_action :authenticate_user!
  
    def home
      # สำหรับสร้างโพสต์ใหม่
      @post = Post.new
  
      # ดึงโพสต์ทั้งหมดมาแสดง (เรียงลำดับจากใหม่ไปเก่า)
      @posts = Post.all.order(created_at: :desc)
  
      # ผู้ใช้ที่เข้าสู่ระบบ
      @user = current_user
  
      # แนะนำผู้ใช้ใหม่ ยกเว้นตัวเอง
      @suggested_users = User.where.not(id: current_user.id).order(created_at: :desc).limit(5)
    end
  
    def show
      # แสดงโปรไฟล์ของผู้ใช้
      @user = User.find(params[:id])
    end
  end