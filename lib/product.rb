class Product
  attr_reader :code, :name, :price

  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  def to_a
    [@code, @name, @price]
  end

  def to_s
    output_name = format('%-7s', @name)
    output_price = format('%6.2f', @price)
    "#{@code} \t #{output_name}\t#{output_price}"
  end
end
