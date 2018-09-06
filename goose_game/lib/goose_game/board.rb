# frozen_string_literal: true

require 'goose_game/position'

module GooseGame
  class Board

    attr_reader :players

    def initialize
      @players = {}
    end

    # @param player_name [String]
    def add_player(player_name)
      raise PlayerExistingException if players.has_key?(player_name)
      players[player_name] = [Position.new(0)]
      true
    end

    def move(player, dice_roll)
      raise PlayerNotFoundException unless players[player]
      last_position(player).next(dice_roll).tap do |new_position|
        players[player] << new_position
      end
    end

    def player_names
      players.keys
    end

    def prev_position(player)
      players[player][-2]
    end

    def last_position(player)
      players[player][-1]
    end

    PlayerExistingException = Class.new(Exception)
    PlayerNotFoundException = Class.new(Exception)
  end
end
