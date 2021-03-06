class ConversationsController < ApplicationController
  before_action :authenticate_player!

  def index
    @players = Player.all
    @conversations = Conversation.where(sender_id: current_player.id)
                                 .or(Conversation.where(recipient_id: current_player.id))
  end

  def create
    @conversation = if Conversation.between(params[:sender_id],
                                            params[:recipient_id]).present?
                      Conversation.between(params[:sender_id],
                                           params[:recipient_id]).first
                    else
                      @conversation = Conversation.create!(conversation_params)
                    end
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
