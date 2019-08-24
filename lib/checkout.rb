require_relative 'basket'

class Checkout
  def initialize(store)
    @store = store
    @products = @store.products
    @sales_rules = @store.sales_rules
    @basket = Basket.new
    @items = @basket.items
  end

  def scan(code)
    raise "#{code} is not a valid item code" unless valid_code?(code)

    product = @store.find(code)
    item = Item.new(product.code, product.price)
    @basket.add(item)
  end

  def clear
    @basket.clear
  end

  def show
    total
    @basket.show
  end

  def total
    @items.each(&:reset)
    @sales_rules.each { |rule| rule.apply(@items) }
    @basket.total = @items.inject(0.0) { |total, item| total + item.price }.round(2)
  end

  private

  def valid_code?(code)
    @store.valid_codes.include?(code)
  end
end
