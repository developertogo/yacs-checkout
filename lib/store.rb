require_relative 'product'

class Store
  attr_reader :sales_rules

  def initialize(sales_rules, products)
    @sales_rules = sales_rules
    @inventory = products.map { |product| [product.code.to_sym, product] }.to_h
  end

  def find(code)
    @inventory[code.to_sym]
  end

  def products_quantity
    @inventory.size
  end

  def products
    @inventory.values
  end

  def valid_codes
    @inventory.values.map(&:code)
  end

  def show_products
    puts "Code \t Name \t\t Price"
    puts "---- \t ---- \t\t -----"
    products.sort_by(&:code).each(&:to_s)
  end

  def show_specials
    puts "Code \t Description"
    puts "---- \t --------------------------------------------------------------"
    @sales_rules.sort_by(&:discount_type).each(&:to_s)
  end
end
