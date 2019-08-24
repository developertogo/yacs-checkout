require_relative '../discounts/base_discount'

class BuyThisGetThatPercentDiscount < BaseDiscount
  def initialize(discount_type:, description: '', this_code:, this_min_items: 1, that_code:, that_max_items: 1, percent_discount:, limit: nil)
    @discount_type = discount_type
    @description = description
    @this_code = this_code
    @this_min_items = this_min_items
    @that_code = that_code
    @that_max_items = that_max_items
    @percent_discount = percent_discount
    @limit = limit
  end

  def apply(items)
    this_orders = items.select { |i| i.code == @this_code }
    that_orders = items.select { |i| i.code == @that_code }
    apply_discount(this_orders, that_orders) if apply_discount?(this_orders, that_orders)
    items
  end

  private

  def apply_discount?(this_orders, that_orders)
    this_orders.size >= @this_min_items && that_orders.size >= @that_max_items
  end

  def discount_amount(that_order)
    that_order.regular_price * @percent_discount / 100
  end

  def apply_discount(this_orders, that_orders)
    limit = 1
    this_orders.each_with_index do |_this_order, i|
      break if limit? && limit.zero?

      that_order = that_orders[i]
      break if that_order.nil? || !that_order.discount_type.empty?

      that_order.discount_type = @discount_type
      that_order.discount_amount = discount_amount(that_order)
      that_order.price -= discount_amount(that_order)

      limit -= 1 if limit?
    end
    this_orders + that_orders
  end
end
