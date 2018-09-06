# frozen_string_literal: true

module GooseGame
  class DiceRoll

    attr_reader :roll

    def initialize(*roll)
      @roll = roll.empty? ? build_random_roll : roll
    end

    def build_random_roll
      [rand_roll, rand_roll]
    end

    def value
      @roll.inject(:+)
    end

    def coerce(other)
      case other
      when Numeric then [other, value]
      else
        raise TypeError, "#{self.class} can't be coerced into #{other.class}"
      end
    end

    def to_s
      roll.join(', ')
    end

  private

    def rand_roll
      (rand * 1_000_000).to_i % 6 + 1
    end
  end
end
