class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    before_action :set_comment, only: [:destroy]
  
    def create
        @comment = @post.comments.new(comment_params)
        @comment.user = current_user
        if @comment.save
          redirect_to post_comments_path(@post), notice: 'Comment was successfully created.'
        else
          redirect_to post_comments_path(@post), alert: 'There was an error creating the comment.'
        end
      end

    def new
        @comment = @post.comments.build
    end
    
    def index
        @comment = @post.comments.build # สร้าง @comment ใหม่เพื่อใช้ในฟอร์ม
        @comments = @post.comments.includes(:user)  # ใช้ includes เพื่อโหลดข้อมูล user ด้วย
    end

    def destroy
        if @comment.user == current_user
          @comment.destroy
          redirect_to post_comments_path(@post), notice: "Comment deleted successfully."
        else
          redirect_to post_comments_path(@post), alert: "You are not authorized to delete this comment."
        end
      end

    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
        @comment = @post.comments.find(params[:id])
      end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end