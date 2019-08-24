require_relative '../lib/basket'
require_relative '../lib/item'

describe Basket do
  subject(:basket) { Basket.new }

  before :each do
    apple = Item.new('AP1', 6.00)
    apple.discount_type = 'APPL'
    apple.discount_amount = 1.50
    apple.price = 4.50

    milk = Item.new('MK1', 4.75)
    milk.discount_type = 'CHMK'
    milk.discount_amount = 4.75
    milk.price = 0

    chia = Item.new('CH1', 3.11)

    basket.add(chia)
    3.times do
      basket.add(apple)
    end
    basket.add(milk)

    basket.total = basket.items.inject(0.0) { |total, item| total + item.price }
  end

  describe '#add' do
    it 'returns item list containing added item' do
      oakmeal = Item.new('OM1', 3.69)
      actual = basket.add(oakmeal)
      expect(oakmeal).to eq(actual)
    end
  end

  describe '#clear' do
    it 'returns empty item list' do
      expect(basket.items.count).not_to eq(0)
      expect(basket.total).not_to eq(0.0)
      basket.clear
      expect(basket.items.count).to eq(0)
      expect(basket.total).to eq(0.0)
    end
  end

  describe '#show' do
    it 'returns output of receipt' do
      basket.show
    end
  end
end
