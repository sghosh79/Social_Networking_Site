class PostsController < ApplicationController
  def index
  end

  def create
    post_params = sanitize_params.merge({user_id: current_user.id})
    @user = User.friendly.find(params[:user_id])
    if current_user.id != @user.id
      post_params.merge!(receiver_id: @user.id ) 
    end
    @post = current_user.posts.create(post_params)
    @my_friends = current_user.my_friends

    @my_friends.each do |friend|
      message = render_to_string(partial: 'shared/feed', locals: {feed: @post})
      PrivatePub.publish_to("/post/new-#{friend.id}", {message: message, reciever_id: friend.id})
    end

    respond_to do |format|
      format.json
      format.js
    end
  end
  
  private
  def sanitize_params
    params.require(:post).permit(:image, :message, :user_id, :receiver_id )
  end
end
