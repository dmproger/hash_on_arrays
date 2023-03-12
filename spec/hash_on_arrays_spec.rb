# frozen_string_literal: true

require_relative '../lib/hash_on_arrays'

RSpec.configure do |config|
  config.default_formatter = 'doc'
end

RSpec.describe HashOnArrays do
  let(:hash) { described_class.new }

  context 'no sets in hash' do
    it 'returns nil on any key' do
      expect(hash.get('a')).to be_nil
      expect(hash.get('aa')).to be_nil
    end
  end

  context 'hash sets without collisions' do
    before do
      hash.set('a', 'value1')
      hash.set('aa', 'value2')
      hash.set('aaa', 'value3')
    end

    it 'returns values by key' do
      expect(hash.get('a')).to eq('value1')
      expect(hash.get('aa')).to eq('value2')
      expect(hash.get('aaa')).to eq('value3')
    end

    it 'updates existing key-value' do
      hash.set('aa', 'foo')

      expect(hash.get('a')).to eq('value1')
      expect(hash.get('aa')).to eq('foo')
      expect(hash.get('aaa')).to eq('value3')
    end

    it 'returns nil on missing key' do
      expect(hash.get('z')).to be_nil
      expect(hash.get('zz')).to be_nil
    end
  end

  context 'hash sets with collisions' do
    before do
      hash.set('a', 'value1')
      hash.set('aa', 'value2')
      hash.set('bb', 'value3')
      hash.set('cc', 'value4')
      hash.set('dd', 'value5')
    end

    it 'returns values by key' do
      expect(hash.get('a')).to eq('value1')
      expect(hash.get('aa')).to eq('value2')
      expect(hash.get('bb')).to eq('value3')
      expect(hash.get('cc')).to eq('value4')
      expect(hash.get('dd')).to eq('value5')
    end

    it 'override collision key-value with last set' do
      hash.set('aa', 'foo')
      hash.set('aa', 'bar')
      expect(hash.get('aa')).to eq('bar')
    end

    it 'updates existing collision key-value' do
      hash.set('aa', 'foo')
      hash.set('cc', 'bar')

      expect(hash.get('a')).to eq('value1')
      expect(hash.get('aa')).to eq('foo')
      expect(hash.get('bb')).to eq('value3')
      expect(hash.get('cc')).to eq('bar')
      expect(hash.get('dd')).to eq('value5')
    end
  end
end
