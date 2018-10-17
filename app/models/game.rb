class Game < ApplicationRecord
#  include KingMove
  validates :white_player, presence: true

  belongs_to :white_player, class_name: :Player
  belongs_to :black_player, class_name: :Player, optional: true
  has_many :pieces, dependent: :delete_all
  scope :available, -> { where(state: 0) }

  enum state: [
    'Waiting for players',
    "White's Turn",
    "Black's Turn",
    'Black Won',
    'White Won',
    'Stalemate'
  ]

  def get_piece(square)
    pieces.where(column: square[:column], row: square[:row]).first
  end

  def square_occupied?(square)
    pieces.where(column: square[:column], row: square[:row]).any?
  end

  def add_pieces_to_board
    Games::AddPieces.call(self)
  end

  def check?(player)
    king = pieces.where(player: player, type: 'King', captured: false).first
    opponent_pieces = pieces.where.not(player: player, captured: true)
    opponent_pieces.each do |piece|
      return true if piece.valid_move?(row: king.row, column: king.column)
    end
    false
  end

  def checkmate?(player)
    return false if !check?(player)
    return false if !endgame?(player)
    checkmate(player)
  end

  def checkmate(player)
    player == white_player ? self.update(state: 3) : self.update(state: 4)
  end

  def stalemate(player)
  end

  def endgame?(player)
    king = pieces.where(player: player, type: 'King', captured: false).first
    opponent_pieces = pieces.where.not(player: player, captured: true)
    check_piece = nil
    opponent_pieces.each do |piece|
      check_piece = piece if piece.valid_move?(row: king.row, column: king.column)
    end
    return false if check_piece.can_obstruct? || check_piece.can_capture?
#    return false if king.can_move?
    true
  end
end
