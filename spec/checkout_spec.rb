require_relative '../lib/checkout.rb'
require_relative '../lib/store.rb'
require_relative '../lib/product.rb'
require_relative '../lib/item.rb'
require_relative '../lib/discounts/two_for_one_discount.rb'
require_relative '../lib/discounts/item_discount.rb'
require_relative '../lib/discounts/buy_this_get_that_percent_discount.rb'

describe Checkout do
  subject(:checkout) do
    sales_rules = [
      TwoForOneDiscount.new(discount_type: 'BOGO', code: 'CF1'),
      ItemDiscount.new(discount_type: 'APPL', code: 'AP1', min_items: 3, discount: 4.50),
      BuyThisGetThatPercentDiscount.new(discount_type: 'CHMK', this_code: 'CH1', this_min_items: 1,
                                        that_code: 'MK1', that_max_items: 1, percent_discount: 100, limit: 1),
      BuyThisGetThatPercentDiscount.new(discount_type: 'APOM', this_code: 'OM1', this_min_items: 1,
                                        that_code: 'AP1', that_max_items: 1, percent_discount: 50)
    ]
    products = [
      Product.new('CH1', 'Chai', 3.11),
      Product.new('AP1', 'Apples', 6.00),
      Product.new('CF1', 'Coffee', 11.23),
      Product.new('MK1', 'Milk', 4.75),
      Product.new('OM1', 'Oatmeal', 3.69)
    ]
    store = Store.new(sales_rules, products)

    Checkout.new(store)
  end

  describe '#scan' do
    it 'scans an item' do
      expect(checkout.scan('CH1').code).to eq(Item.new('CH1', 3.11).code)
    end

    it 'scans an invalid item' do
      expect { checkout.scan('UU1') }.to raise_error(RuntimeError)
    end
  end

  describe '#clear' do
    it 'invokes basket class to clear itself' do
      expect_any_instance_of(Basket).to receive(:clear)
      checkout.clear
    end
  end

  describe '#total' do
    context 'when basket is empty' do
      it 'returns 0' do
        expect(checkout.total).to eq(0)
      end
    end

    context 'when basket is not empty and no discounts' do
      subject(:checkout) do
        sales_rules = []
        products = [
          Product.new('CH1', 'Chai', 3.11),
          Product.new('AP1', 'Apples', 6.00),
          Product.new('CF1', 'Coffee', 11.23),
          Product.new('MK1', 'Milk', 4.75),
          Product.new('OM1', 'Oatmeal', 3.69)
        ]
        store = Store.new(sales_rules, products)

        Checkout.new(store)
      end

      it 'returns a nonzero total' do
        checkout.scan('CH1')
        checkout.scan('AP1')
        checkout.scan('CF1')
        checkout.scan('MK1')

        items = [
          Item.new('CH1', 3.11),
          Item.new('AP1', 6.00),
          Item.new('CF1', 11.23),
          Item.new('MK1', 4.75)
        ]
        total = items.inject(0.0) { |sum, item| sum + item.price }

        expect(checkout.total).to eq(total)
      end
    end

    context 'when basket has sale items' do
      subject(:checkout) do
        sales_rules = [
          TwoForOneDiscount.new(discount_type: 'BOGO', code: 'CF1'),
          ItemDiscount.new(discount_type: 'APPL', code: 'AP1', min_items: 3, discount: 4.50),
          BuyThisGetThatPercentDiscount.new(discount_type: 'CHMK', this_code: 'CH1', this_min_items: 1,
                                            that_code: 'MK1', that_max_items: 1, percent_discount: 100, limit: 1),
          BuyThisGetThatPercentDiscount.new(discount_type: 'APOM', this_code: 'OM1', this_min_items: 1,
                                            that_code: 'AP1', that_max_items: 1, percent_discount: 50)
        ]
        products = [
          Product.new('CH1', 'Chai', 3.11),
          Product.new('AP1', 'Apples', 6.00),
          Product.new('CF1', 'Coffee', 11.23),
          Product.new('MK1', 'Milk', 4.75),
          Product.new('OM1', 'Oatmeal', 3.69)
        ]
        store = Store.new(sales_rules, products)

        Checkout.new(store)
      end

      it 'applies buy chai get milk free discount' do
        checkout.scan('CH1')
        checkout.scan('AP1')
        checkout.show
        checkout.scan('CF1')
        checkout.scan('MK1')

        items = [
          Item.new('CH1', 3.11),
          Item.new('AP1', 6.00),
          Item.new('CF1', 11.23),
          Item.new('MK1', 4.75)
        ]
        no_discount_total = items.inject(0.0) { |total, item| total + item.regular_price }
        expect(checkout.total).to eq(20.34)
        expect(checkout.total).to_not eq(no_discount_total)

        checkout.show
      end

      it 'applies discount if any' do
        checkout.scan('MK1')
        checkout.scan('AP1')

        items = [
          Item.new('AP1', 6.00),
          Item.new('MK1', 4.75)
        ]
        no_discount_total = items.inject(0.0) { |total, item| total + item.price }

        expect(checkout.total).to eq(10.75)
        expect(checkout.total).to eq(no_discount_total)

        checkout.show
      end

      it 'applies one get one free discount' do
        checkout.scan('CF1')
        checkout.scan('CF1')

        items = [
          Item.new('CF1', 11.23),
          Item.new('CF1', 11.23)
        ]
        no_discount_total = items.inject(0.0) { |total, item| total + item.price }

        expect(checkout.total).to eq(11.23)
        expect(checkout.total).to_not eq(no_discount_total)

        checkout.show
      end

      it 'applies 3+ apples get $4.50 discount' do
        checkout.scan('AP1')
        checkout.scan('AP1')
        checkout.scan('CH1')
        checkout.scan('AP1')

        items = [
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('AP1', 6.00),
          Item.new('CH1', 3.11)
        ]
        no_discount_total = items.inject(0.0) { |total, item| total + item.price }

        expect(checkout.total).to eq(16.61)
        expect(checkout.total).to_not eq(no_discount_total)

        checkout.show
      end

      it 'applies buy oakmeal get 50% off apple discount' do
        checkout.scan('OM1')
        checkout.scan('AP1')
        checkout.show
        checkout.scan('OM1')
        checkout.scan('AP1')

        items = [
          Item.new('AP1', 6.00),
          Item.new('OM1', 3.69),
          Item.new('AP1', 6.00),
          Item.new('OM1', 3.69)
        ]
        no_discount_total = items.inject(0.0) { |total, item| total + item.price }

        expect(checkout.total).to eq(13.38)
        expect(checkout.total).to_not eq(no_discount_total)

        checkout.show
      end
    end
  end

  describe '#valid_code? (private)' do
    it 'verifies if code is a valid code' do
      expect(checkout.send(:valid_code?, 'CH1')).to be_truthy
    end

    it 'verifies if code is not a valid code' do
      expect(checkout.send(:valid_code?, 'UU1')).to be_falsy
    end
  end
end
