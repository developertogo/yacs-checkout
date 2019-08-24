require_relative '../lib/product'

describe Product do
  subject(:product) { Product.new('CH1', 'Chai', 3.11) }

  describe '#code' do
    it 'returns product code' do
      expect(product.code).to eq('CH1')
    end
  end

  describe '#name' do
    it 'returns product name' do
      expect(product.name).to eq('Chai')
    end
  end

  describe '#price' do
    it 'returns product price' do
      expect(product.price).to eq(3.11)
    end
  end

  describe '#to_a' do
    it 'returns product array' do
      expect(product.to_a).to eq([product.code, product.name, product.price])
    end
  end
end
