# frozen_string_literal: true

module GooseGame
  class Position

    FINAL = 63

    attr_reader :index

    def initialize(index)
      @index = index
    end

    def next(dice_roll)
      offset = index + dice_roll
      case offset
      when FINAL then WinPosition.new
      when 6 then BridgePosition.new
      when 5, 9, 14, 18, 23, 27 then GoosePosition.new(offset, dice_roll)
      else
        offset > FINAL ? BouncePosition.new(offset) : Position.new(offset)
      end
    end

    def to_s
      0 == index ? 'Start' : index.to_s
    end
  end

  class WinPosition < Position
    def initialize
      super(FINAL)
    end
  end

  class BouncePosition < Position
    def initialize(index)
      super(FINAL - (index % FINAL))
    end
  end

  class BridgePosition < Position
    def initialize
      super(12)
    end
  end

  class GoosePosition < Position
    attr_reader :next_position
    alias_method :subsequent, :next

    def initialize(index, dice_roll)
      super(index)
      @next_position = subsequent(dice_roll)
    end

    def next(dice_roll)
      next_position.next(dice_roll)
    end

    def to_s
      next_position.to_s
    end
  end
end
