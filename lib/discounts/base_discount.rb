class BaseDiscount
  attr_reader :priority

  @discount_type = ''
  @priority = 0
  @decription = ''
  @min_items = 1
  @limit = nil

  def apply(items)
    raise 'This is not implemented!'
  end

  def to_s
    puts @discount_type + " \t " + @description
  end

  protected

  def apply_discount?(orders)
    orders.size >= @min_items
  end

  def limit?
    !@limit.nil?
  end

  def apply_discount(*args)
    raise 'This is not implemented!'
  end
end
