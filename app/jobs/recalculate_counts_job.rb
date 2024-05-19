class RecalculateCountsJob < ApplicationJob
      queue_as :default
    
      def perform
        Application.find_each do |application|
          application.update(chats_count: application.chats.count)
          application.chats.find_each do |chat|
            chat.update(messages_count: chat.messages.count)
          end
        end
      end
end
    