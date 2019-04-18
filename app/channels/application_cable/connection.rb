# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
    end

    private

    def find_verified_player
      if verified_player = Player.find_by(id: cookies.signed['user.id'])
        verified_player
      else
        reject_unauthorized_connection
      end
    end
  end
end
