
class Oystercard

attr_reader :balance

BALANCE_LIMIT = 90
MINIMUM_BALANCE = 1
MINIMUM_CHARGE = 1

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    fail "Cannot top up this amount!! Max limit = #{BALANCE_LIMIT}" if amount + balance > BALANCE_LIMIT
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    fail "Not enough money. Please top up." if balance < MINIMUM_BALANCE
    @in_journey = true
  end

  def touch_out
    deduct MINIMUM_CHARGE
    @in_journey = false
  end

end
