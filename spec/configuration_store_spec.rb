require 'spec_helper'

describe MetaCommit::ConfigurationStore do
  describe '#merge' do
    it 'adds new values to configuration' do
      configuration_store = MetaCommit::ConfigurationStore.new(MetaCommit::Configuration.new.fill_from_hash({}))

      configuration_store
          .merge(MetaCommit::Configuration.new.fill_from_hash({'foo' => 'baz', 'baz' => 'foo', }))

      expect(configuration_store.get(:foo)).to be == 'baz'
      expect(configuration_store.get(:baz)).to be == 'foo'
    end
    it 'overrides values of stored configuration' do
      configuration_store = MetaCommit::ConfigurationStore.new(MetaCommit::Configuration.new.fill_from_hash({'foo' => 'bar', 'baz' => 'baz', }))

      configuration_store
          .merge(MetaCommit::Configuration.new.fill_from_hash({'foo' => 'baz', 'baz' => 'foo', }))

      expect(configuration_store.get(:foo)).to be == 'baz'
      expect(configuration_store.get(:baz)).to be == 'foo'
    end
    it 'overrides nested values of stored configuration' do
      configuration_store = MetaCommit::ConfigurationStore.new(
          MetaCommit::Configuration.new.fill_from_hash(
              {
                  'foo' => 'foo',
                  'bar' => 'bar',
                  'baz' => {
                      'foo' => 'foo',
                      'bar' => 'bar',
                  }
              })
      )

      configuration_store
          .merge(MetaCommit::Configuration.new.fill_from_hash({
                                                                  'foo' => 'foo',
                                                                  'bar' => 'bar',
                                                                  'baz' => {
                                                                      'foo' => 'www',
                                                                      'bar' => 'www',
                                                                  }
                                                              }))

      expect(configuration_store.get(:baz)).to be == {"foo"=>"www", "bar"=>"www"}
    end
  end
end