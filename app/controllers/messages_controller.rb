class MessagesController < ApplicationController

  def index
    @messages = Message.all
  end

  def create
    @reciever = User.find(params[:reciever_id])
    msg_params = check_params.merge(to: @reciever.id)
    @message = current_user.messages.create!(msg_params)
    message_to = render_to_string(partial: 'message_to', locals: {message: @message})
    message_from = render_to_string(partial: 'message_from', locals: {message: @message})
    PrivatePub.publish_to("/messages/new-#{current_user.id}", {message: message_from, reciever_id: @reciever.id, reciever_name: @reciever.full_name, msg_id: @message.id })
    PrivatePub.publish_to("/messages/new-#{@reciever.id}", {message: message_to, reciever_id: current_user.id, reciever_name: current_user.full_name, msg_id: @message.id})
    render json: {success: true}
  end

  private
  def check_params
    params.require(:message).permit(:content, :from, :to)
  end
end

