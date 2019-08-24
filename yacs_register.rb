require_relative 'lib/checkout.rb'
require_relative 'lib/store.rb'
require_relative 'lib/product.rb'
require_relative 'lib/item.rb'
require_relative 'lib/discounts/two_for_one_discount.rb'
require_relative 'lib/discounts/item_discount.rb'
require_relative 'lib/discounts/buy_this_get_that_percent_discount.rb'

# Print variables
def prompt
  print '> '
end

def newline
  puts "\n"
end

sales_rules = [
  TwoForOneDiscount.new(discount_type: 'BOGO', code: 'CF1',
                        description: 'Buy-One-Get-One-Free Special on Coffee. (Unlimited)'),
  ItemDiscount.new(discount_type: 'APPL', code: 'AP1', min_items: 3, discount: 4.50,
                   description: 'If you buy 3 or more bags of Apples, the price drops to $4.50'),
  BuyThisGetThatPercentDiscount.new(discount_type: 'CHMK', this_code: 'CH1', this_min_items: 1,
                                    that_code: 'MK1', that_max_items: 1, percent_discount: 100, limit: 1,
                                    description: 'Purchase a box of Chai and get milk free. (Limit 1)'),
  BuyThisGetThatPercentDiscount.new(discount_type: 'APOM', this_code: 'OM1', this_min_items: 1,
                                    that_code: 'AP1', that_max_items: 1, percent_discount: 50,
                                    description: 'Purchase a bag of Oatmeal and get 50% off a bag of Apples')
]
products = [
  Product.new('CH1', 'Chai', 3.11),
  Product.new('AP1', 'Apples', 6.00),
  Product.new('CF1', 'Coffee', 11.23),
  Product.new('MK1', 'Milk', 4.75),
  Product.new('OM1', 'Oatmeal', 3.69)
]
store = Store.new(sales_rules, products)

checkout = Checkout.new(store)

option = 0
loop do
  puts '
    Welcome to The Farmer\'s Market

    1. Scan product
    2. Total
    3. Clear basket
    4. Find product
    5. Product list
    6. Offers - 1st Year Anniversary Sale
    7. Exit
  '
  prompt

  option = gets.chomp
  temp = option.to_i
  option = temp.zero? ? option : temp
  newline

  case option
  when 1, 's'
    puts 'Please enter code:'
    prompt
    code = gets.chomp
    newline
    begin
      checkout.scan(code)
    rescue StandardError
      puts 'Invalid code'
    else
      puts 'Product was scanned successfully'
    end
  when 2, 't'
    checkout.show
  when 3, 'c'
    puts 'Are you sure you\'d like to clear the basket? [Y/n]'
    checkout.clear if gets.chomp == 'Y'
  when 4, 'f'
    puts 'Please enter product code:'
    prompt
    code = gets.chomp
    product = store.find(code)
    newline
    if !product.nil?
      puts "Code \t Name \t\t Price"
      puts "---- \t ---- \t\t -----"
      puts product.to_s
    else
      puts 'Product not found. Invalid code.'
      puts 'Please try again...'
    end
  when 5, 'p'
    puts store.show_products
  when 6, 'o'
    store.show_specials
  when 7, 'e', 'q'
    puts 'Are you sure you\'d like to exit? [Y/n]'
    break if gets.chomp == 'Y'
  else
    puts 'Invalid option.'
    puts 'Enter option # or option 1st letter.'
    puts 'Please try again...'
  end
end

puts "\nThank you for shopping at The Farmer\'s Market!"
puts "Come back again...\n\n"
