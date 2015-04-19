require 'spec_helper'

describe ClusterPoint do
  before(:each) do
    Item.clear_contains
    Item.clear_contains_many
  end
  
  describe ClusterPoint::Contains do
    it 'returns nil when not initialized' do
      expect(Item.get_contains).to be_nil
    end

    it 'adds element to array' do
      Item.contains(:test)
      expect(Item.get_contains).to eq([:test])
    end

    it 'don\'t duplicate element' do
      Item.contains(:test)
      Item.contains(:test)
      expect(Item.get_contains).to eq([:test])
    end

    it 'adds n elements to array' do
      Item.contains(:test)
      Item.contains(:test_h)
      expect(Item.get_contains).to match_array([:test, :test_h])
    end

    it 'adds contains elements when defined in class' do
      class ItemTest < ClusterPoint::Document
        contains :test
        contains :test_h
      end
      expect(ItemTest.get_contains).to match_array([:test, :test_h])
    end

    it 'can call attributes method' do
      Item.contains(:test)
      expect(Item.get_contains).to eq([:test])
      item = Item.from_hash({}, Item)
      expect{item.test_attributes={}}.to_not raise_error
    end

  end

  describe ClusterPoint::ContainsMany do
    
    it 'returns nil when not initialized' do
      expect(Item.get_contains_many).to be_nil
    end

    it 'adds element to array' do
      Item.contains_many(:test)
      expect(Item.get_contains_many).to eq([:test])
    end

    it 'don\'t duplicate element' do
      Item.contains_many(:test)
      Item.contains_many(:test)
      expect(Item.get_contains_many).to eq([:test])
    end

    it 'adds n elements to array' do
      Item.contains_many(:test)
      Item.contains_many(:test_h)
      expect(Item.get_contains_many).to match_array([:test, :test_h])
    end

    it 'adds contains many elements when defined in class' do
      class ItemTestMany < ClusterPoint::Document
        contains_many :test
        contains_many :test_h
      end
      expect(ItemTestMany.get_contains_many).to match_array([:test, :test_h])
    end

    it 'can call attributes method' do
      Item.contains_many(:tests)
      expect(Item.get_contains_many).to eq([:tests])
      item = Item.from_hash({}, Item)
      expect{item.tests_attributes={}}.to_not raise_error
    end

  end

  it 'returns both contains and contains many when both defined' do
    class ItemTestAll < ClusterPoint::Document
      contains_many :test
      contains_many :test_h
      contains :blank
      contains :blank_h
    end
    expect(ItemTestAll.get_contains_many).to match_array([:test, :test_h])
    expect(ItemTestAll.get_contains).to match_array([:blank, :blank_h])
  end
end
