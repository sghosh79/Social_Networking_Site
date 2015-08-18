class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.friendships.accepted_requests
    @pending_friendships = current_user.friendships.pending_requests
    @friends_request = current_user.inverse_friendships.pending_requests
    @users = User.suggested_friends(current_user)
    @friends = current_user.friends
  end

  def create
    params[:friend_id] = User.find_by(slug: params[:friend_id]).id if params[:friend_id].to_i==0
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], status: 0)
    if @friendship.save
      flash[:success] = "Friend request has been sent"
      message = render_to_string(partial: 'friendrequest_notification', locals: {sender: current_user, created_at: @friendship.created_at})
      PrivatePub.publish_to("/notification/friend_request-#{@friendship.friend.id}", {message: message, reciever_id: @friendship.friend.id})
      redirect_to friendships_path
    else
      flash[:error] = "Unable to add friend."
      redirect_to friendships_path
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    my_friend_friendship = @friendship.friend.friendships.where(friend_id: current_user.id).last
    my_friend_friendship.update_attributes(status: 3, removed_at: Time.now) if my_friend_friendship

    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to friendships_path
  end

  def accept
    friend_request = User.friendly.find(params[:friend_id])
    request_from = friend_request.friendships.pending_requests.where(friend_id: current_user).last
    if request_from.blank?
      flash[:error] = "Invalid friend request"
      redirect_to friendships_path and return
    end
    request_from.status = 1
    friendship = current_user.friendships.build(:friend_id => request_from.user.id, status: 1)

    if friendship.save and request_from.save
      flash[:message] = "Removed friendship."
      redirect_to friendships_path
    else
      flash[:error] = "Can't create friendship!"
      redirect_to friendships_path
    end
  end

  def show_friend_requests_notification
    @pending_requests = current_user.my_pending_friend_requests.order('created_at desc')
    respond_to do |format|
      format.json
      format.js
    end
  end

end
