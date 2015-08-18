class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @posts = @user.profile_posts
  end

  def show_friend
    @user = current_user.my_friends.select{|f| f.slug==params[:id] || f.id==params[:id]}.first
    @posts = @user.profile_posts
    render 'show'
  end

  def update
    @user = current_user.update_attributes(sanitize_params)
    redirect_to current_user
  end

  def like
    @like_to = Post.find(params[:feed_id]) if params[:type]=="Post"
    @like_to = Comment.find(params[:feed_id]) if params[:type]=="Comment"
    @like_to.likes.create(user_id: current_user.id)
    respond_to do |format|
      format.json
      format.js
    end
  end

  def unlike
    feed_like = current_user.likes.where("likeable_id=? and likeable_type=?", params[:feed_id], params[:type]).first
    @unlike_to = params[:feed_id]
    feed_like.destroy
    respond_to do |format|
      format.json
      format.js
    end
  end

  def comment
    @comment = current_user.comments.new(message: params[:comment][:message], post_id: params[:feed_id])
    @comment.save
    respond_to do |format|
      format.json
      format.js
    end
  end

  def delete_comment
  end

  private
  def sanitize_params
    params.require(:user).permit(
      :profile_pic, :first_name, :last_name, :password)
  end

end
