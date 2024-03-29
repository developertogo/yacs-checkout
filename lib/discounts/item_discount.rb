require_relative '../discounts/base_discount'

class ItemDiscount < BaseDiscount
  def initialize(discount_type:, description: '', priority:, code:, min_items:, discount:, limit: nil)
    @discount_type = discount_type
    @description = description
    @priority = priority
    @code = code
    @min_items = min_items
    @discount = discount
    @limit = limit
  end

  def apply(items)
    orders = items.select { |i| i.code == @code }
    apply_discount(orders) if apply_discount?(orders)
  end

  private

  def apply_discount(orders)
    count = 0
    discount_amount = @discount / @min_items
    orders.each do |order|
      next unless count < @min_items && order.discount_type.empty?

      order.discount_type = @discount_type
      order.discount_amount = discount_amount
      order.price -= discount_amount
      count += 1
    end
    orders
  end
end
