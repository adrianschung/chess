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
    return false if king.nil?
    opponent_pieces = pieces.where.not(player: player, captured: true)
    return true if find_check(opponent_pieces, king)
    false
  end

  def check_endgame(player)
    check?(player) ? checkmate(player) : stalemate(player)
  end

  protected

  def checkmate(player)
    return unless check?(player) && king_trapped?(player)
    player == white_player ? update(state: 3) : update(state: 4)
  end

  def stalemate(player)
    return if check?(player) || !king_trapped?(player)
    update(state: 5)
  end

  def king_trapped?(player)
    # Check if the game is in a stalemate or checkmate scenario
    king = pieces.where(player: player, type: 'King', captured: false).first
    return false if king.can_move?
    opponent_pieces = pieces.where.not(player: player, captured: true)
    check_piece = nil
    check_piece = find_check(opponent_pieces, king)
    return false if check_piece.can_obstruct? || check_piece.can_capture?
    true
  end

  def find_check(pieces, king)
    pieces.each do |piece|
      return piece if piece.valid_move?(row: king.row, column: king.column)
    end
    false
  end
end
