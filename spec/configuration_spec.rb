require 'rspec'

describe MetaCommit::Configuration, test_construct: true do
  describe 'values access' do
    it 'sets / gets values' do
      subject.set(:key, :val)
      expect(subject.get(:key)).to be :val
    end
  end
  describe '#fill_from_hash' do
    it 'converts keys to symbols and sets values from hash' do
      subject.fill_from_hash({'foo' => 'bar', baz: :bar, :bar => nil})

      expect(subject.get(:foo)).to eq('bar')
      expect(subject.get(:baz)).to eq(:bar)
      expect(subject.get(:bar)).to eq(nil)
    end
  end
end
