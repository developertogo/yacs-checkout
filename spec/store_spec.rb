require_relative '../lib/store.rb'
require_relative '../lib/discounts/two_for_one_discount.rb'
require_relative '../lib/discounts/item_discount.rb'
require_relative '../lib/discounts/buy_this_get_that_percent_discount.rb'

describe Store do
  subject(:store) do
    sales_rules = [
      TwoForOneDiscount.new(discount_type: 'BOGO', code: 'CF1'),
      ItemDiscount.new(discount_type: 'APPL', code: 'AP1', min_items: 3, discount: 4.50),
      BuyThisGetThatPercentDiscount.new(discount_type: 'CHMK',
                                        this_code: 'CH1', this_min_items: 1,
                                        that_code: 'MK1', that_max_items: 1,
                                        percent_discount: 100, limit: 1),
      BuyThisGetThatPercentDiscount.new(discount_type: 'APOM', this_code: 'OM1',
                                        this_min_items: 1, that_code: 'AP1',
                                        that_max_items: 1, percent_discount: 50)
    ]
    products = [
      Product.new('CH1', 'Chai', 3.11),
      Product.new('AP1', 'Apples', 6.00),
      Product.new('CF1', 'Coffee', 11.23),
      Product.new('MK1', 'Milk', 4.75),
      Product.new('OM1', 'Oatmeal', 3.69)
    ]
    Store.new(sales_rules, products)
  end

  describe '#products_quantity' do
    it 'returns correct product quantity in inventory' do
      expect(store.products.size).to eq(5)
    end
  end

  describe '#find' do
    it 'find product by code in inventory' do
      expect(store.find('OM1').to_a).to match_array(store.products.last.to_a)
    end

    it 'does not find product not in inventory' do
      expect(store.find('TBD').to_a).to be_empty
    end
  end

  describe '#products' do
    it 'returns all products in inventory' do
      expect(store.products.count).to eq(5)
    end
  end

  describe '#valid_codes' do
    it 'returns valid codes in inventory' do
      codes = []
      store.products.each { |product| codes << product.code }
      expect(store.valid_codes).to match_array(codes)
    end
  end

  describe '#sales_rules' do
    it 'returns all sales rules' do
      expect(store.sales_rules.count).to eq(4)
    end
  end
end
