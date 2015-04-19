require 'spec_helper'

describe ClusterPoint::ModificationMethods do
  describe 'merge' do
    describe 'hash with one key' do
      before(:each) do
        @item = Item.from_hash({test: "TEST"}, Item)
        @item_test = @item
      end
      it 'don\'t make changes when empty hash given' do
        @item.merge({})
        expect(@item_test).to eq(@item_test)
      end

      it 'changes value when hash with key given' do
        @item.merge({test: "TEST1"})
        expect(@item.test).to eq("TEST1")
      end

      it 'adds value when hash with non existing key given' do
        @item.merge({test_h: "TEST1"})
        expect(@item.test).to eq("TEST")
        expect(@item.test_h).to eq("TEST1")
      end
    end
    describe 'document with contains' do
      before do
        class MainItem < ClusterPoint::Document
          contains :item
        end
      end
      before(:each) do
        @main_item = MainItem.from_hash({test: "TEST", item: {a: "AA"}}, MainItem)
        @main_item_test = @main_item
        @item = @main_item.item
      end
      it 'don\'t make changes in subdocument when only main changed' do
        @main_item.merge({test: "TEST1"})
        expect(@main_item.test).to eq("TEST1")
        expect(@main_item.item.class).to eq(Item)
        expect(@main_item.item).to eq(@item)
      end
      it 'make changes in subdocument when such given' do
        @main_item.merge({test: "TEST1", item: {a: "AAA"}})
        expect(@main_item.test).to eq("TEST1")
        expect(@main_item.item.class).to eq(Item)
        expect(@main_item.item.a).to eq("AAA")
      end
      it 'make changes in subdocument when _attributes given' do
        @main_item.merge({item_attributes: {a: "AAA", _destroy: "0"}})
        expect(@main_item.item.class).to eq(Item)
        expect(@main_item.item.a).to eq("AAA")
      end
      it 'removes subdocument when _destroy given' do
        @main_item.merge({item_attributes: {a: "AAA", _destroy: "1"}})
        expect(@main_item.item).to be_nil
      end
    end
    describe 'document with contains_many' do
      before do
        class MainItem < ClusterPoint::Document
          contains_many :items
        end
      end
      before(:each) do
        @main_item = MainItem.from_hash({test: "TEST", items: {a: "AA"}}, MainItem)
        @main_item_test = @main_item
        @items = @main_item.items
      end
      it 'don\'t make changes in subdocuments when only main changed' do
        @main_item.merge({test: "TEST1"})
        expect(@main_item.test).to eq("TEST1")
        expect(@main_item.items[0].class).to eq(Item)
        expect(@main_item.items).to eq(@items)
      end
      it 'make changes in subdocument when such given' do
        @main_item.merge({test: "TEST1", items_attributes: {"0" => {a: "AAA"}}})
        expect(@main_item.test).to eq("TEST1")
        expect(@main_item.items[0].class).to eq(Item)
        expect(@main_item.items[0].a).to eq("AAA")
      end
      it 'removes subdocument when _destroy given' do
        @main_item.merge({items_attributes: {"0" => {a: "AAA", _destroy: "1"}}})
        expect(@main_item.items).to eq([])
      end
    end
  end
end
