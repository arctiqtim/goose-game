# frozen_string_literal: true

require 'spec_helper'
require 'goose_game/dice_roll'

RSpec.describe GooseGame::DiceRoll do
  describe 'initialize' do
    context 'when no roll is provided' do
      it 'generates a random roll' do
        roll = described_class.new
        expect(roll.roll.size).to eq(2)
        expect(roll.roll[0]).to be <= 6
        expect(roll.roll[1]).to be <= 6
      end
    end
  end

  describe 'value' do
    let(:roll) { described_class.new(5, 2) }

    it 'is the sum of roll components' do
      expect(roll.value).to eq(7)
    end
  end

  describe 'coerce' do
    context 'when the other object is a numeric' do
      let(:roll) { described_class.new(2, 2) }

      it 'sums the value' do
        expect(3 + roll).to eq(7)
      end
    end
  end
end
