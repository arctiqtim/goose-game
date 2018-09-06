# frozen_string_literal: true

require 'spec_helper'
require 'goose_game/position'

RSpec.describe GooseGame::Position do
  let(:position) { described_class.new(0) }

  describe 'next' do
    context 'when next position is 63' do
      it 'returns a WinPosition' do
        expect(position.next(63)).to be_a(GooseGame::WinPosition)
      end
    end

    context 'when next position is > 63' do
      it 'bounces back' do
        next_p = position.next(65)
        expect(next_p.index).to eq(61)
        expect(next_p).to be_a(GooseGame::BouncePosition)
      end
    end

    context 'when next position is 6' do
      it 'goes to 12 through the bridge' do
        next_p = position.next(6)
        expect(next_p.index).to eq(12)
        expect(next_p).to be_a(GooseGame::BridgePosition)
      end
    end

    context 'when next position is a goose position' do
      it 'returns a goose position' do
        [5, 9, 14, 18, 23, 27].each do |value|
          next_p = position.next(value)
          expect(next_p.index).to eq(value)
          expect(next_p).to be_a(GooseGame::GoosePosition)
        end
      end

      it 'provides the next position' do
        goose = position.next(5)
        expect(goose).to be_a(GooseGame::GoosePosition)
        expect(goose.next_position).to be_a(GooseGame::Position)
        expect(goose.next_position.index).to eq(10)
      end
    end
  end
end
