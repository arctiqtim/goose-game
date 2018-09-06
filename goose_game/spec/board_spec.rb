# frozen_string_literal: true

require 'spec_helper'
require 'goose_game/board'
require 'goose_game/dice_roll'

RSpec.describe GooseGame::Board do
  let(:board) { described_class.new }

  describe 'add_player' do
    context 'when the player does not exist' do
      it 'returns true' do
        expect(board.add_player('foo')).to eq(true)
      end

      it 'adds the player to players hash' do
        board.add_player('foo')
        expect(board.players['foo']).to be_instance_of(Array)
      end
    end

    context 'when the player already exists' do
      before { board.add_player('foo') }

      it 'raises an exception' do
        expect { board.add_player('foo') }.to raise_error(described_class::PlayerExistingException)
      end
    end
  end

  describe 'move' do
    context 'when the player does not exist' do
      it 'raises PlayerNotFoundException' do
        expect { board.move('xx', nil) }.to raise_error(described_class::PlayerNotFoundException)
      end
    end

    it 'returns the new position' do
      board.add_player('foo')
      position = board.move('foo', GooseGame::DiceRoll.new(2, 2))
      expect(position.index).to eq(4)
    end
  end
end
