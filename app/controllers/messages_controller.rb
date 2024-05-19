class MessagesController < ApplicationController
  before_action :set_chat

  def create
    ActiveRecord::Base.transaction do
      @message = @chat.messages.new(message_params)
      if @message.save
        UpdateMessagesCountJob.perform_later(@chat.id)
        render json: @message.slice(:number, :body), status: :created
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end
  end

  def show
    @message = @chat.messages.find_by(number: params[:number])
    if @message
      render json: @message.slice(:body)
    else
      render json: { error: 'Message not found' }, status: :not_found
    end
  end

  def index
    @messages = @chat.messages
    render json: @messages.map { |message| { number: message.number, body: message.body } }
  end

  private

  def set_chat
    application = Application.find_by(token: params[:application_token])
    if application
      @chat = application.chats.find_by(number: params[:chat_number])
      render json: { error: 'Chat not found' }, status: :not_found unless @chat
    else
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
