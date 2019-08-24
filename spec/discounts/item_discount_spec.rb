require_relative '../../lib/discounts/item_discount'
require_relative '../../lib/item'

describe ItemDiscount do
  subject(:item_discount) { ItemDiscount.new(discount_type: 'APPL', priority: 2, code: 'AP1', min_items: 3, discount: 4.50) }

  describe '#apply_discount? (private)' do
    context 'when min items is met' do
      before :each do
        @orders = [
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00)
        ]
      end

      it 'returns true' do
        expect(item_discount.send(:apply_discount?, @orders)).to be_truthy
      end
    end

    context 'when min items is not met' do
      before :each do
        @orders = [
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00)
        ]
      end

      it 'returns false' do
        expect(item_discount.send(:apply_discount?, @orders)).to be_falsy
      end
    end
  end

  describe '#apply_discount (private method)' do
    context 'when min items is met' do
      before :each do
        @orders = [
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00)
        ]
      end

      it 'returns orders with discounted prices' do
        orders = item_discount.send(:apply_discount, @orders)
        orders.each_with_index do |order, i|
          expect(order.code).to eq('AP1')
          if i < 3
            expect(order.discount_type).to eq('APPL')
            expect(order.discount_amount).to eq(1.50)
            expect(order.price).to eq(4.50)
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(6.00)
            expect(order.price).to eq(6.00)
          end
        end
      end
    end
  end

  describe '#apply' do
    context 'when min items is met' do
      before :each do
        @items = [
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('CH1', 3.00),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00)
        ]
      end

      it 'returns orders with discounted prices' do
        orders = item_discount.send(:apply, @items)
        orders.each do |order|
          next unless order.code == 'AP1'

          expect(order.code).to eq('AP1')
          if order.discount_type == 'APPL'
            expect(order.discount_type).to eq('APPL')
            expect(order.discount_amount).to eq(1.50)
            expect(order.price).to eq(4.50)
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(6.00)
            expect(order.price).to eq(6.00)
          end
        end
      end
    end
  end
end
