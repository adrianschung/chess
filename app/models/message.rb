class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :player

  validates_presence_of :body, :conversation_id, :player_id

  def message_time
    created_at.strftime('%m/%d/%y at %l:%M %p')
  end
end
