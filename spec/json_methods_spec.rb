require 'spec_helper'

describe ClusterPoint::JsonMethods do
  describe 'as_json' do
    it 'returns empty json when empty hash given for document creation' do
      expect(Item.from_hash({}, Item).as_json).to eq("{}")
    end
    it 'returns json with one element when hash with one element given' do
      expect(Item.from_hash({test: "TEST"}, Item).as_json).to eq("{\"test\":\"TEST\"}")
    end
    it 'substitute " with \" when string contains "' do
      expect(Item.from_hash({test: "TEST\""}, Item).as_json).to eq("{\"test\":\"TEST\\\"\"}")
    end
    describe 'document with contains' do
      before do
        class MainItem < ClusterPoint::Document
          contains :item
        end
      end
      it 'don\'t contain subdocument hash when it\'s nil' do
        item = MainItem.from_hash({test: "TEST"}, MainItem)
        expect(item.as_json).to eq("{\"test\":\"TEST\"}")
      end
      it 'contain subdocument when it given' do
        item = MainItem.from_hash({test: "TEST", item: {a: "AA"}}, MainItem)
        expect(item.as_json).to eq("{\"test\":\"TEST\",\"item\":{\"a\":\"AA\"}}")
      end
    end
    describe 'document with contains many' do
      before do
        class MainItem < ClusterPoint::Document
          contains_many :items
        end
      end
      it 'don\'t contain subdocuments when there are none' do
        item = MainItem.from_hash({test: "TEST"}, MainItem)
        expect(item.as_json).to eq("{\"test\":\"TEST\"}")
      end
      it 'contain subdocument when it given' do
        item = MainItem.from_hash({test: "TEST", items: {"0" => {a: "AA"}}}, MainItem)
        expect(item.as_json).to eq("{\"test\":\"TEST\",\"items\":[{\"a\":\"AA\"}]}")
      end
      it 'contains n subdocuments when n given' do
        item = MainItem.from_hash({test: "TEST", items: {"0" => {a: "AA"},"1" => {b: "BB"},"2" => {c: "CC"}}}, MainItem)
        expect(item.as_json).to eq("{\"test\":\"TEST\",\"items\":[{\"a\":\"AA\"},{\"b\":\"BB\"},{\"c\":\"CC\"}]}")
      end
    end
  end
end
