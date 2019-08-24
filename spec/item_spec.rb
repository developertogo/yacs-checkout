require_relative '../lib/item'

describe Item do
  subject(:item) { Item.new('AP1', 6.00) }

  describe '#code' do
    it 'returns item code' do
      expect(item.code).to eq('AP1')
    end
  end

  describe '#regular_price' do
    it 'returns item regular_price' do
      expect(item.regular_price).to eq(6.00)
    end
  end

  describe '#price' do
    it 'returns item price' do
      expect(item.price).to eq(6.00)
    end
  end

  describe '#discount_type' do
    it 'returns item discount_type initial value' do
      expect(item.discount_type).to eq('')
    end
  end

  describe '#discount_amount' do
    it 'returns item discount_amount initial value' do
      expect(item.discount_amount).to eq(0)
    end
  end

  describe '#reset' do
    it 'returns reseted item' do
      item.discount_type = 'APPL'
      item.discount_amount = 1.50
      item.price = 4.50
      item.reset
      expect(item.code).to eq('AP1')
      expect(item.discount_type).to be_empty
      expect(item.discount_amount).to eq(0)
      expect(item.price).to eq(item.regular_price)
    end
  end

  describe '#to_a' do
    it 'returns an array' do
      expect(item.to_a).to eq([item.code, item.discount_type, item.regular_price, item.discount_amount, item.price])
    end
  end
end
