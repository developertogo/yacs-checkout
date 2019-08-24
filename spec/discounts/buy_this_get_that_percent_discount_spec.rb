require_relative '../../lib/discounts/buy_this_get_that_percent_discount'
require_relative '../../lib/item'

describe BuyThisGetThatPercentDiscount do
  subject(:buy_this_get_that_percent_discount) do
    BuyThisGetThatPercentDiscount.new(discount_type: 'CHMK', priority: 4, this_code: 'CH1',
                                      that_code: 'MK1', percent_discount: 100, limit: 1)
  end

  describe '#apply_discount? (private)' do
    context 'when min this items and max that items are met' do
      before :each do
        @this_orders = [
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23)
        ]
        @that_orders = [
          Item.new('MK1', 4.75)
        ]
      end

      it 'returns true' do
        expect(buy_this_get_that_percent_discount.send(:apply_discount?, @this_orders, @that_orders)).to be_truthy
      end
    end

    context 'when min this items is not met' do
      before :each do
        @this_orders = []
        @that_orders = [
          Item.new('MK1', 4.75)
        ]
      end

      it 'returns false' do
        expect(buy_this_get_that_percent_discount.send(:apply_discount?, @this_orders, @that_orders)).to be_falsy
      end
    end

    context 'when max that items is not met' do
      before :each do
        @this_orders = [
          Item.new('CF1', 11.23)
        ]
        @that_orders = []
      end

      it 'returns false' do
        expect(buy_this_get_that_percent_discount.send(:apply_discount?, @this_orders, @that_orders)).to be_falsy
      end
    end
  end

  describe '#apply_discount (private method)' do
    context 'when min this items and max that items are met and unlimited' do
      subject(:buy_this_get_that_percent_discount) do
        BuyThisGetThatPercentDiscount.new(discount_type: 'APOM', priority: 4, this_code: 'OM1',
                                          that_code: 'AP1', percent_discount: 50)
      end

      before :each do
        @this_orders = [
          Item.new('OM1', 3.69),
          Item.new('OM1', 3.69)
        ]

        @that_orders = [
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00)
        ]
      end

      it 'returns orders with that item discount applied' do
        offer = 0
        offer_total = @this_orders.size

        orders = buy_this_get_that_percent_discount.send(:apply_discount, @this_orders, @that_orders)
        orders.each do |order|
          if order.code == 'OM1'
            expect(order.code).to eq('OM1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          elsif order.code == 'AP1' && offer < offer_total
            expect(order.code).to eq('AP1')
            expect(order.discount_type).to eq('APOM')
            expect(order.discount_amount).to eq(3.00)
            expect(order.price).to eq(3.00)
            offer += 1
          elsif order.code == 'AP1'
            expect(order.code).to eq('AP1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          end
        end
      end
    end

    context 'when min items is met and limit one offer' do
      before :each do
        @this_orders = [
          Item.new('CH1', 3.11),
          Item.new('CH1', 3.11)
        ]

        @that_orders = [
          Item.new('MK1', 4.75),
          Item.new('MK1', 4.75),
          Item.new('MK1', 4.75)
        ]
      end

      it 'returns just the 1st order with discount offer applied' do
        limit = 1
        orders = buy_this_get_that_percent_discount.send(:apply_discount, @this_orders, @that_orders)

        orders.each do |order|
          if order.code == 'CH1'
            expect(order.code).to eq('CH1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          elsif order.code == 'MK1' && limit == 1
            limit += 1
            expect(order.code).to eq('MK1')
            expect(order.discount_type).to eq('CHMK')
            expect(order.discount_amount).to eq(4.75)
            expect(order.price).to eq(0.0)
          elsif order.code == 'MK1'
            expect(order.code).to eq('MK1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          end
        end
      end
    end
  end

  describe '#apply' do
    context 'when that item is free limited one offer' do
      before :each do
        @items = [
          Item.new('CH1', 3.11),
          Item.new('AP1', 6.00),
          Item.new('CF1', 11.23),
          Item.new('MK1', 4.75),
          Item.new('CH1', 3.11),
          Item.new('CF1', 11.23),
          Item.new('MK1', 4.75),
          Item.new('MK1', 4.75)
        ]
      end

      it 'returns that item 1st order with offer applied' do
        limit = 1
        orders = buy_this_get_that_percent_discount.send(:apply, @items)
        orders.each do |order|
          if order.code == 'CH1'
            expect(order.code).to eq('CH1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          elsif order.code == 'MK1' && limit == 1
            limit += 1
            expect(order.code).to eq('MK1')
            expect(order.discount_type).to eq('CHMK')
            expect(order.discount_amount).to eq(4.75)
            expect(order.price).to eq(0.0)
          elsif order.code == 'MK1'
            expect(order.code).to eq('MK1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          end
        end
      end
    end

    context 'when that item is 50% off unlimited offer' do
      subject(:buy_this_get_that_percent_discount) do
        BuyThisGetThatPercentDiscount.new(discount_type: 'APOM', priority: 4, this_code: 'OM1',
                                          that_code: 'AP1', percent_discount: 50)
      end

      before :each do
        @items = [
          Item.new('OM1', 3.69),
          Item.new('AP1', 6.00),
          Item.new('CF1', 11.23),
          Item.new('MK1', 4.75),
          Item.new('OM1', 3.69),
          Item.new('AP1', 6.00),
          Item.new('OM1', 3.69),
          Item.new('AP1', 6.00),
          Item.new('CH1', 3.11),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('MK1', 4.75),
          Item.new('MK1', 4.75)
        ]
      end

      it 'returns that item order with offer applied' do
        offer = 0
        offer_total = @items.select { |i| i.code == 'OM1' }.size

        orders = buy_this_get_that_percent_discount.send(:apply, @items)
        orders.each do |order|
          if order.code == 'OM1'
            expect(order.code).to eq('OM1')
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          elsif order.code == 'AP1' && offer < offer_total
            expect(order.code).to eq('AP1')
            expect(order.discount_type).to eq('APOM')
            expect(order.discount_amount).to eq(3.00)
            expect(order.price).to eq(3.00)
            offer += 1
          else
            expect(order.discount_type).to be_empty
            expect(order.discount_amount).to eq(0)
            expect(order.regular_price).to eq(order.price)
          end
        end
      end
    end
  end
end
