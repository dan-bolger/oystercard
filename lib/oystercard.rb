
class Oystercard

attr_reader :balance
attr_reader :journeys
attr_reader :entry_station
attr_reader :exit_station

BALANCE_LIMIT = 90
MINIMUM_BALANCE = 1
MINIMUM_CHARGE = 1

  def initialize
    @balance = 0
    @journeys = { }
  end

  def top_up(amount)
    fail "Cannot top up this amount!! Max limit = #{BALANCE_LIMIT}" if amount + balance > BALANCE_LIMIT
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station)
    fail "Not enough money. Please top up." if balance < MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    send(:deduct, MINIMUM_CHARGE)
    @entry_station = nil
    @exit_station = station
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
