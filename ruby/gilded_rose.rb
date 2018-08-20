class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when "Aged Brie"
        if item.quality < 50
          item.quality = item.quality + 1
        end
        item.sell_in = item.sell_in - 1
        if item.sell_in < 0
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      when "Backstage passes to a TAFKAL80ETC concert"
        if item.quality < 50
          item.quality = item.quality + 1
          if item.sell_in < 11
            if item.quality < 50
              item.quality = item.quality + 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality = item.quality + 1
            end
          end
        end
        item.sell_in = item.sell_in - 1
        if item.sell_in < 0
          item.quality = item.quality - item.quality
        end
      when "Sulfuras, Hand of Ragnaros"
        if item.quality < 50
          item.quality = item.quality + 1
        end
      when "Conjured Mana Cake"
        if item.sell_in > 0
          item.quality = item.quality - 2
          item.sell_in = item.sell_in - 1
        else
          item.quality = item.quality - 4
          item.sell_in = item.sell_in - 1
        end
        item.quality = 0 if item.quality < 0
      else
        if item.quality > 0
          item.quality = item.quality - 1
        end
        item.sell_in = item.sell_in - 1
        if item.sell_in < 0
          if item.quality > 0
            item.quality = item.quality - 1
          end
        end
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
