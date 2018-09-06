require 'tty-prompt'
require 'goose_game'

Command = Struct.new(:name, :args)

@prompt = TTY::Prompt.new
@board = GooseGame::Board.new

@commands = [
  [/\Aadd player (?<name>.+)\z/, :add_player],
  [/\Amove (?<name>.+) (?<dice0>\d+), (?<dice1>\d+)\z/, :move_player],
  [/\Amove (?<name>.+)\z/, :move_player]
]

def translate_command(input_line)
  match_data = nil
  entry = @commands.detect { |pair| match_data = pair[0].match(input_line) }
  entry.nil? ? Command.new : Command.new(entry[1], match_data.captures)
end

def add_player(name)
  @board.add_player(name)
  @prompt.say("Players: #{@board.player_names.join(', ')}")
rescue GooseGame::Board::PlayerExistingException
  @prompt.say("#{name}: already existing player")
end

def move_player(*args)
  name = args[0]
  dice_roll =
    if args[1] && args[2]
      GooseGame::DiceRoll.new(args[1].to_i, args[2].to_i)
    else
      GooseGame::DiceRoll.new
    end
  apply_move(name, dice_roll)
rescue GooseGame::Board::PlayerNotFoundException
  @prompt.error('This player does not exist')
end

def apply_move(name, dice_roll)
  position = @board.move(name, dice_roll)
  prev_position = @board.prev_position(name)
  case position
  when GooseGame::WinPosition
    @prompt.say(
      "#{name} rolls #{dice_roll}. #{name} moves from " \
      "#{prev_position} to #{position}. " \
      "#{name} wins!!"
    )

  when GooseGame::BouncePosition
    @prompt.say(
      "#{name} rolls #{dice_roll}. #{name} moves from " \
      "#{prev_position} to 63. " \
      "#{name} bounces! #{name} returns to #{position}"
    )

  when GooseGame::BridgePosition
    @prompt.say(
      "#{name} rolls #{dice_roll}. #{name} moves from #{prev_position} " \
      "to The Bridge. #{name} jumps to #{position}"
    )

  when GooseGame::GoosePosition
    @prompt.say(
      "#{name} rolls #{dice_roll}. #{name} moves from #{prev_position} to #{position.index}, The Goose."
    )
    subsequent = position.next_position
    loop do
      break if !subsequent.is_a?(GooseGame::GoosePosition)
      @prompt.say(
        "#{name} moves again and goes to #{subsequent.index}, The Goose."
      )
      subsequent = subsequent.next_position
    end
    @prompt.say("#{name} moves again and goes to #{subsequent}")

  else
    @prompt.say(
      "#{name} rolls #{dice_roll}. "\
      "#{name} moves from #{prev_position} to #{position}"
    )
  end
end

while 'quit' != (input = @prompt.ask('> ')) do
  case (command = translate_command(input)).name
  when :add_player
    add_player(*command.args)
  when :move_player
    move_player(*command.args)
  else
    @prompt.error('Unknown command')
  end
end
