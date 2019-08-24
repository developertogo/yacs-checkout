class Basket
  attr_reader :items
  attr_accessor :total

  def initialize
    @items = []
    @total = 0.0
  end

  def add(item)
    @items.push(item)
    item
  end

  def clear
    @items.clear
    @total = 0.0
  end

  def show
    puts ''
    puts 'The Farmer\'s Market'
    puts ''
    puts "Item\t\t    \t\t     Price"
    puts "----\t\t    \t\t     -----"

    @items.each do |item|
      output_price = format(' %9.2f', item.regular_price)
      puts "#{item.code}\t\t    \t\t#{output_price}"
      unless item.discount_type.empty?
        negative_amount = -item.discount_amount
        output_discount = format('%10.2f', negative_amount)
        puts "   \t\t#{item.discount_type}\t\t#{output_discount}"
      end
    end
    puts '------------------------------------------'
    output_total = ('$' + total.round(2).to_s).rjust(8)
    puts "    \t\t    \t\t  #{output_total}"
  end
end
