# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
    end

    private

    def find_verified_player
      verified_player = Player.find_by(id: cookies.signed['player.id'])
      reject_unauthorized_connection unless verified_player
    end
  end
end
