require 'spec_helper'
require 'action_controller'

describe ClusterPoint::HashMethods do
  describe 'from_hash' do
    it 'creates object with Item class when empty hash given' do
      item = Item.from_hash({}, Item)
      expect(item.class).to eq(Item)
    end

    it 'creates object with Item class and attribute when hash given' do
      item = Item.from_hash({test: "TEST"}, Item)
      expect(item.test).to eq("TEST")
    end

    it 'creates object with Item class and id attribute' do
      item = Item.from_hash({test: "TEST", id: 1}, Item)
      expect(item.test).to eq("TEST")
      expect(item.id).to eq 1
    end

    it 'creates object with Item class and id attribute' do
      item = Item.from_hash({test: "TEST", "id" => 1}, Item)
      expect(item.test).to eq("TEST")
      expect(item.id).to eq 1
    end

    describe 'with contains attribute' do
      before do
        class ContTest < ClusterPoint::Document
        end
        class ItemContain < ClusterPoint::Document
          contains :cont_test
        end
      end

      it 'creates object with ItemContains class and nil contains element when empty hash given' do
        item = ItemContain.from_hash({}, ItemContain)
        expect(item.class).to eq(ItemContain)
        expect(item.cont_test).to be_nil
      end

      it 'creates object with ItemContains class and contains element when hash with it given' do
        item = ItemContain.from_hash({test: "TEST", cont_test: {a: "AA"}}, ItemContain)
        expect(item.class).to eq(ItemContain)
        expect(item.test).to eq("TEST")
        expect(item.cont_test.class).to eq(ContTest)
        expect(item.cont_test.a).to eq("AA")
      end

      it 'creates object with correct class and elements when contains many classes' do
        class ContainsItems < ClusterPoint::Document
          contains :cont_test
          contains :item_contain
        end
        item = ContainsItems.from_hash({test: "TEST", cont_test: {a: "AA"}, item_contain: {b: "BB"}}, ContainsItems)
        expect(item.class).to eq(ContainsItems)
        expect(item.test).to eq("TEST")
        expect(item.cont_test.class).to eq(ContTest)
        expect(item.cont_test.a).to eq("AA")
        expect(item.item_contain.class).to eq(ItemContain)
        expect(item.item_contain.b).to eq("BB")
      end
    end

    describe 'with contains many attribute' do
      before do
        class ContTest < ClusterPoint::Document
        end
        class ItemContain < ClusterPoint::Document
          contains_many :cont_tests
        end
      end

      it 'creates object with ItemContains class and nil contains element when empty hash given' do
        item = ItemContain.from_hash({}, ItemContain)
        expect(item.class).to eq(ItemContain)
        expect(item.conttest).to be_nil
      end

      it 'creates object with ItemContains class and array with contains element when hash with it given' do
        item = ItemContain.from_hash({test: "TEST", cont_tests: {a: "AA"}}, ItemContain)
        expect(item.class).to eq(ItemContain)
        expect(item.test).to eq("TEST")
        expect(item.cont_tests.class).to eq(Array)
        expect(item.cont_tests[0].class).to eq(ContTest)
        expect(item.cont_tests[0].a).to eq("AA")
      end

      it 'creates object with correct class and element arrays when contains many classes' do
        class ContainsItems < ClusterPoint::Document
          contains_many :cont_tests
          contains_many :item_contains
        end
        item = ContainsItems.from_hash({test: "TEST", cont_tests: {a: "AA"}, item_contains: {b: "BB"}}, ContainsItems)
        expect(item.class).to eq(ContainsItems)
        expect(item.test).to eq("TEST")
        expect(item.cont_tests.class).to eq(Array)
        expect(item.cont_tests[0].class).to eq(ContTest)
        expect(item.cont_tests[0].a).to eq("AA")
        expect(item.item_contains.class).to eq(Array)
        expect(item.item_contains[0].class).to eq(ItemContain)
        expect(item.item_contains[0].b).to eq("BB")
      end
    end
  end

  describe 'from_array' do
    it 'returns empty array when nil given' do
      expect(Item.from_array(nil, Item)).to eq([])
    end

    describe 'when hash given' do
      it 'returns array with one element of Item class when empty hash given' do
        array = Item.from_array({}, Item)
        expect(array.class).to eq(Array)
        expect(array.size).to eq 1
        expect(array[0].class).to eq(Item)
      end

      it 'returns empty array when element with _destroy given' do
        array = Item.from_array({"_destroy" => "1"}, Item)
        expect(array).to eq([])
        array = Item.from_array({_destroy: "1"}, Item)
        expect(array).to eq([])
      end

      describe 'like array' do
        it 'returns array with element of Item class' do
          array = Item.from_array({"0" => {test: "TEST"}}, Item)
          expect(array.class).to eq(Array)
          expect(array.size).to eq 1
          expect(array[0].class).to eq(Item)
          expect(array[0].test).to eq("TEST")
        end

        it 'returns array with one element of Item class when two given but one of them contains _destroy' do
          array = Item.from_array({"0" => {test: "TEST"}, "1" => {_destroy: "1"}}, Item)
          expect(array.class).to eq(Array)
          expect(array.size).to eq 1
          expect(array[0].class).to eq(Item)
        end
      end
    end

    describe 'when array given' do
      it 'returns array with n elements of Item class when array with n hashes given' do
        array = Item.from_array([{a: "AA"},{b: "BB"},{c: "CC"}], Item)
        expect(array.class).to eq(Array)
        expect(array.size).to eq 3
        array.each do |elm|
          expect(elm.class).to eq(Item)
        end
      end
      it 'returns array with n-1 elements of Item class when array with n hashes given but one of them contains _destroy' do
        array = Item.from_array([{a: "AA"},{b: "BB", _destroy: "1"},{c: "CC"}], Item)
        expect(array.class).to eq(Array)
        expect(array.size).to eq 2
        array.each do |elm|
          expect(elm.class).to eq(Item)
        end
      end
    end
  end

  describe 'like_array' do
    it 'returns true when array given' do
      expect(Item.like_array([])).to eq(true)
    end

    it 'returns false when non array/hash given' do
      expect(Item.like_array("STRING")).to eq(false)
    end

    it 'returns false when empty hash given' do
      expect(Item.like_array({})).to eq(false)
    end

    it 'returns false when simple hash given' do
      expect(Item.like_array({test: "TEST"})).to eq(false)
    end

    it 'returns true when hash like array given' do
      expect(Item.like_array({"0" => {a: "AAA"}, "1" => {b: "BBB"}})).to eq(true)
    end

    it 'returns false when hash like array given, but elements are not hashes' do
      expect(Item.like_array({"0" => "AAA", "1" => "BBB"})).to eq(false)
    end

  end

  describe 'remove_attribs' do
    it 'don\'t return error when empty hash given' do
      h = ClusterPoint::HashMethods.remove_attribs({})
      expect(h).to eq({})
    end

    it 'removes _attributes from key when it contains' do
      h = ClusterPoint::HashMethods.remove_attribs({test_attributes: "Test"})
      expect(h).to eq({"test" => "Test"})
    end

    it 'checks for ActionController::Parameters when it\'s defined' do
      params = ActionController::Parameters.new({
        test_attributes: "Test"
      })
      h = ClusterPoint::HashMethods.remove_attribs(params)
      expect(h).to eq({"test" => "Test"})
    end

    it 'calls reqursive when hash contains hash' do
      h = {test_attributes: {att_attributes: "TTT"}}
      h = ClusterPoint::HashMethods.remove_attribs(h)
      expect(h).to eq({"test" => {"att" => "TTT"}})
    end
  end
end
