require 'spec_helper'

describe MetaCommit::Configuration do
  describe 'values access' do
    it 'sets / gets value' do
      subject.set(:key, :val)
      expect(subject.get(:key)).to be :val
    end
    it 'overrides existing value' do
      subject.set(:key, :val)
      subject.set(:key, :new)
      expect(subject.get(:key)).to be :new
    end
  end
  describe '#fill_from_hash' do
    it 'sets values from hash' do
      subject.fill_from_hash({'foo' => 'bar', baz: :bar, :bar => nil})

      expect(subject.get(:foo)).to eq('bar')
      expect(subject.get(:baz)).to eq(:bar)
      expect(subject.get(:bar)).to eq(nil)
    end
  end
  describe '#fill_from_yaml_file' do
    it 'raises error when file is missing' do
      expect {
        subject.fill_from_yaml_file(path_to_fixture_of_config('missing_config.yml'))
      }.to raise_error MetaCommit::Errors::MissingConfigError
    end
    it 'sets values from valid file' do
      subject.fill_from_yaml_file(path_to_fixture_of_config('valid_config.yml'))

      expect(subject.get(:extensions)).to include('ruby_support').and include('css_support').and include('filesystem').and include('builtin')
    end
  end
end
