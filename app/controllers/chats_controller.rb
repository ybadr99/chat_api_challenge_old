class ChatsController < ApplicationController
      before_action :set_application
    
      def create
        @chat = @application.chats.new
        if @chat.save
          render json: @chat.slice(:number), status: :created
        else
          render json: @chat.errors, status: :unprocessable_entity
        end
      end
    
      def show
        @chat = @application.chats.find_by(number: params[:number])
        if @chat
          render json: @chat.slice(:number)
        else
          render json: { error: 'Chat not found' }, status: :not_found
        end
      end
    
      def index
        @chats = @application.chats.select(:number)
        render json: @chats.map { |chat| { number: chat.number } }
      end
    
      private
    
      def set_application
        @application = Application.find_by(token: params[:application_token])
        render json: { error: 'Application not found' }, status: :not_found unless @application
      end
end
    