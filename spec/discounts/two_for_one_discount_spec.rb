require_relative '../../lib/discounts/two_for_one_discount'
require_relative '../../lib/item'

describe TwoForOneDiscount do
  subject(:two_for_one_discount) { TwoForOneDiscount.new(discount_type: 'BOGO', priority: 3, code: 'CF1') }

  describe '#apply_discount? (private)' do
    context 'when min items is met' do
      before :each do
        @orders = [
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23)
        ]
      end

      it 'returns true' do
        expect(two_for_one_discount.send(:apply_discount?, @orders)).to be_truthy
      end
    end

    context 'when min items is not met' do
      before :each do
        @orders = [
          Item.new('CF1', 11.23)
        ]
      end

      it 'returns false' do
        expect(two_for_one_discount.send(:apply_discount?, @orders)).to be_falsy
      end
    end
  end

  describe '#apply_discount (private method)' do
    before :each do
      @orders = [
        Item.new('CF1', 11.23),
        Item.new('CF1', 11.23),
        Item.new('CF1', 11.23),
        Item.new('CF1', 11.23),
        Item.new('CF1', 11.23)
      ]
    end

    context 'when min items is met and unlimited' do
      it 'returns orders with 2nd item free' do
        orders = two_for_one_discount.send(:apply_discount, @orders)
        orders.each_with_index do |order, i|
          expect(order.code).to eq('CF1')
          if (i + 1).even?
            expect(order.discount_type).to eq('BOGO')
            expect(order.discount_amount).to eq(order.regular_price)
            expect(order.price).to eq(0.0)
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(11.23)
            expect(order.price).to eq(11.23)
          end
        end
      end
    end

    context 'when min items is met and limit one offer' do
      let(:limit) { 1 }
      subject(:two_for_one_discount) { TwoForOneDiscount.new(discount_type: 'BOGO', priority: 3, code: 'CF1', limit: limit) }

      it 'returns just the 1st order with 2nd item free' do
        orders = two_for_one_discount.send(:apply_discount, @orders)
        orders.each_with_index do |order, i|
          expect(order.code).to eq('CF1')
          if (i + 1).even? && i <= limit
            expect(order.discount_type).to eq('BOGO')
            expect(order.discount_amount).to eq(order.regular_price)
            expect(order.price).to eq(0.0)
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(11.23)
            expect(order.price).to eq(11.23)
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
          Item.new('CF1', 11.23),
          Item.new('AP1', 6.00),
          Item.new('CF1', 11.23),
          Item.new('CH1', 3.00),
          Item.new('CF1', 11.23),
          Item.new('AP1', 6.00),
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23),
          Item.new('AP1', 6.00)
        ]
      end

      it 'returns orders with 2nd item free' do
        orders = two_for_one_discount.send(:apply, @items)
        orders.each do |order|
          next unless order.code == 'CF1'

          if order.discount_type == 'BOGO'
            expect(order.discount_amount).to eq(11.23)
            expect(order.price).to eq(0.0)
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(11.23)
            expect(order.price).to eq(11.23)
          end
        end
      end
    end
  end
end
