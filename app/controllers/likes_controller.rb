class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
  
    # สร้าง Like ใหม่
  def create
    @like = @post.likes.find_or_create_by(user: current_user)
    respond_to do |format|
      format.js   # ใช้ JavaScript เพื่อตอบกลับการเพิ่ม Like
    end
  end

  # ลบ Like
  def destroy
    @like = @post.likes.find_by(user: current_user)
    @like.destroy if @like
    respond_to do |format|
      format.js   # ใช้ JavaScript เพื่อตอบกลับการลบ Like
    end
  end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  end