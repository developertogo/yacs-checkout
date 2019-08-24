require_relative '../discounts/base_discount'

class TwoForOneDiscount < BaseDiscount
  def initialize(discount_type:, description: '', code:, limit: nil)
    @discount_type = discount_type
    @description = description
    @code = code
    @min_items = 2
    @limit = limit
  end

  def apply(items)
    orders = items.select { |i| i.code == @code }
    apply_discount(orders) if apply_discount?(orders)
  end

  private

  def apply_discount(orders)
    orders.each_slice(@min_items) do |items|
      break if limit? && @limit.zero?

      next unless items.size > @min_items - 1

      free_item = items[1]
      next unless free_item.discount_type.empty?

      free_item.discount_type = @discount_type
      free_item.discount_amount = free_item.regular_price
      free_item.price = 0.0

      @limit -= 1 if limit?
    end
    orders
  end
end
