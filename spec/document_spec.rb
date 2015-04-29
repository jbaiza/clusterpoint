require 'spec_helper'

describe ClusterPoint do
  describe 'get_cp' do
    it 'returns ClusterPointAdapter from class' do
      expect(Item.get_cp.class).to eq(ClusterPoint::ClusterPointAdapter)
    end
    it 'returns ClusterPointAdapter from instance' do
      expect(Item.from_hash({test: "TEST"}, Item).get_cp.class).to eq(ClusterPoint::ClusterPointAdapter)
    end
  end

  describe 'new_from_hash' do
    it 'contains only document type when given empty hash' do
      item = Item.new_from_hash({})
      expect(item.class).to eq(Item)
      expect(item["type"]).to eq("ITEM")
    end
    it 'contains document type when given non empty hash' do
      item = Item.new_from_hash({test: "TEST"})
      expect(item.class).to eq(Item)
      expect(item["type"]).to eq("ITEM")
      expect(item["test"]).to eq("TEST")
    end
  end

  describe 'persisted' do
    it 'returns false when item doesn\'t contain id field' do
      expect(Item.from_hash({test: "TEST"}, Item).persisted?).to eq(false)
    end
    it 'returns true when item contains id field' do
      expect(Item.from_hash({test: "TEST", id: "1"}, Item).persisted?).to eq(true)
    end
  end
  describe 'document methods' do
    it 'has hash methods' do
      expect(ClusterPoint::Document.methods).to include(:from_hash, :from_array, :like_array)
    end
    it 'has json methods' do
      expect(ClusterPoint::Document.instance_methods).to include(:as_json)
    end
    it 'has finder methods' do
      expect(ClusterPoint::Document.methods).to include(:all, :where, :find, :get, :get_some)
    end
  end
end
