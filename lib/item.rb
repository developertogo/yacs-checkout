class Item
  attr_reader :code, :regular_price
  attr_accessor :discount_type, :discount_amount, :price

  def initialize(code, price)
    @code = code
    @discount_type = ''
    @regular_price = price
    @discount_amount = 0
    @price = price
  end

  def reset
    @discount_type = ''
    @discount_amount = 0
    @price = @regular_price
  end

  def to_a
    [@code, @discount_type, @regular_price, @discount_amount, @price]
  end
end
