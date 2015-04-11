require 'spec_helper'

describe Chef::Validation::HashExt do
  context '.dig' do
    it 'can access a simple element' do
      expect(described_class.dig(node, 'cookbook/timeout')).to eq(200)
    end

    it 'can access and return a nested structure' do
      expect(described_class.dig(node, 'cookbook/party/yes')).to eq(node['cookbook']['party']['yes'])
    end

    it 'can access elements in an array' do
      expect(described_class.dig(node, 'cookbook/volumes/1/device')).to eq('/dev/sdo')
    end
  end
end
