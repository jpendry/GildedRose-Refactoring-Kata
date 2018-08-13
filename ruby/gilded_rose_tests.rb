require File.join(File.dirname(__FILE__), 'gilded_rose')
require 'test/unit'

class TestUntitled < Test::Unit::TestCase
  def test_foo
    items = [Item.new('foo', 0, 0)]
    GildedRose.new(items).update_quality()
    assert_equal items[0].name, "foo"
  end

  # Once the sell by date has passed,
  # Quality degrades twice as fast
  def test_quality_degrades_twice_as_fast
    items = [Item.new("foo", 1, 10)]
    GildedRose.new(items).update_quality
    assert_equal 0, items[0].sell_in
    assert_equal 9, items[0].quality

    GildedRose.new(items).update_quality
    assert_equal -1, items[0].sell_in
    assert_equal 7, items[0].quality
  end

  # The Quality of an item is never negative
  def test_quality_is_never_negative
    items = [Item.new("foo", 1, 0)]
    GildedRose.new(items).update_quality
    assert_equal 0, items[0].sell_in
    assert_equal 0, items[0].quality
  end

  # "Aged Brie" actually increases in Quality the older it gets
  def test_aged_brie_quality_increases_with_age
    items = [Item.new("Aged Brie", 10, 10)]
    GildedRose.new(items).update_quality
    assert_equal 9, items[0].sell_in
    assert_equal 11, items[0].quality
  end

  # The Quality of an item is never more than 50
  def test_quality_of_item_never_more_than_50
    items = [
      Item.new('Aged Brie', 10, 50),
      Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 50)
    ]
    GildedRose.new(items).update_quality
    assert_equal 9, items[0].sell_in
    assert_equal 50, items[0].quality

    assert_equal 9, items[1].sell_in
    assert_equal 50, items[1].quality
  end

  # "Sulfuras", being a legendary item,
  # never has to be sold or decreases in Quality
  def test_sulfuras_never_has_to_be_sold_or_decreases_quality
    items = [Item.new("Sulfuras, Hand of Ragnaros", 10, 80)]
    GildedRose.new(items).update_quality
    assert_equal 10, items[0].sell_in
    assert_equal 80, items[0].quality
  end

  # "Backstage passes", like aged brie,
  # increases in Quality as its SellIn value approaches;
  # Quality increases by 2 when there are 10 days or less
  # and by 3 when there are 5 days or less
  # but Quality drops to 0 after the concert
  def test_backstage_passes
    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 20, 10)]
    GildedRose.new(items).update_quality
    assert_equal 19, items[0].sell_in
    assert_equal 11, items[0].quality

    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10)]
    GildedRose.new(items).update_quality
    assert_equal 9, items[0].sell_in
    assert_equal 12, items[0].quality

    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10)]
    GildedRose.new(items).update_quality
    assert_equal 4, items[0].sell_in
    assert_equal 13, items[0].quality

    items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)]
    GildedRose.new(items).update_quality
    assert_equal -1, items[0].sell_in
    assert_equal 0, items[0].quality
  end

  def test_conjured_items
    # Items degrade twice as fast
    items = [Item.new('Conjured Mana Cake', 20, 10)]
    GildedRose.new(items).update_quality
    assert_equal 19, items[0].sell_in
    assert_equal 8, items[0].quality

    items = [Item.new('Conjured Mana Cake', 0, 10)]
    GildedRose.new(items).update_quality
    assert_equal -1, items[0].sell_in
    assert_equal 6, items[0].quality

    # Quality never decreases below 0
    items = [Item.new('Conjured Mana Cake', 10, 0)]
    GildedRose.new(items).update_quality
    assert_equal 9, items[0].sell_in
    assert_equal 0, items[0].quality

    items = [Item.new('Conjured Mana Cake', 10, 1)]
    GildedRose.new(items).update_quality
    assert_equal 9, items[0].sell_in
    assert_equal 0, items[0].quality
  end
end
