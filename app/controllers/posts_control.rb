class PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy] # ป้องกันการแก้ไขโพสต์คนอื่น
  
    def index
        @posts = Post.all.order(created_at: :desc) # แสดงโพสต์ทั้งหมด (เรียงจากใหม่ไปเก่า)
        @post = Post.new # สำหรับฟอร์มสร้างโพสต์
        @posts = Post.order(created_at: :desc).limit(5) # แสดงโพสต์ล่าสุด 5 รายการ
        @all_posts = Post.order(created_at: :desc) # แสดงโพสต์ทั้งหมด
        if params[:query].present?
            @posts = Post.where("title LIKE ? OR content LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
          else
            @posts = Post.all
          end
      end
  
    def show
      @post = Post.find(params[:id])
      @post.increment_views!
      @comments = @post.comments
      @comment = @post.comments.build  # สร้าง comment ใหม่สำหรับฟอร์ม

      if params[:search].present? # ตรวจสอบว่ามีคำค้นหาหรือไม่
        @posts = Post.where('title LIKE ?', "%#{params[:search]}%").order(created_at: :desc) # ค้นหาโพสต์ที่ title ตรงกับคำค้นหา
      else
        @posts = Post.all.order(created_at: :desc) # แสดงโพสต์ทั้งหมดหากไม่มีการค้นหา
      end
      @post = Post.new
    end
  
    def new
      @post = Post.new
    end
  
    def create
        @post = current_user.posts.build(post_params) # เชื่อมโยงโพสต์กับผู้ใช้ที่ล็อกอิน
        if @post.save
          redirect_to home_path, notice: 'Post was successfully created.'
        else
          flash[:alert] = 'There was a problem creating your post.'
          @posts = Post.all.order(created_at: :desc) # โหลดโพสต์เพื่อแสดงผลใหม่
          render :index # เพื่อให้ฟอร์มยังคงแสดงอยู่ในหน้า home
        end
      end
  
    def edit
    end
  
    def update
        # Action สำหรับบันทึกข้อมูลที่แก้ไขแล้ว
        if @post.update(post_params)
          redirect_to home_path, notice: "Post updated successfully."
        else
          render :edit, alert: "Failed to update post."
        end
      end    
  
    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        redirect_to home_path, notice: 'Post was successfully destroyed.'
    end
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end

    def find_post
        @post = Post.find(params[:id]) # ค้นหาโพสต์ตาม ID
      end
  
    def post_params
      params.require(:post).permit(:title, :content)
    end

    def authorize_user!
        redirect_to posts_path, alert: "You are not authorized to perform this action." unless @post.user == current_user
      end
  end