require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    context 'Objet normal' do
      it "does not change the name" do
        items = [Item.new("foo", 0, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].name).to eq "foo"
      end
      
      context 'Quand la date de péremption est passée' do
        it 'la qualité se dégrade deux fois plus rapidement.' do
          # given
          items = [Item.new("foo", 0, 8)]
          # when
          GildedRose.new(items).update_quality()
          GildedRose.new(items).update_quality()
          # then
          expect(items[0].quality).to eq(4)
        end
      end
      
      context 'Quand la date de péremption n\'est pas passée' do
        it 'la qualité se dégrade normalement' do
          # given
          items = [Item.new("foo", 4, 8)]
          # when
          GildedRose.new(items).update_quality()
          GildedRose.new(items).update_quality()
          # then
          expect(items[0].quality).to eq(6)
        end
        
        it 'la qualité ne peut pas être inférieure à zéro' do
          # given
          items = [Item.new("foo", 1, 1)]
          # when
          GildedRose.new(items).update_quality()
          GildedRose.new(items).update_quality()
          GildedRose.new(items).update_quality()
          # then
          expect(items[0].quality).to eq(0)
        end
      end
    end

    context "Aged Brie" do
      # given
      items = [Item.new("Aged Brie", 4, 48)]

      it 'la qualité augmente avec le temps' do
        # when
        GildedRose.new(items).update_quality()
        # then
        expect(items[0].quality).to eq(49)
      end
      
      it 'la qualité ne peut pas dépasser 50' do
        # when
        GildedRose.new(items).update_quality()
        GildedRose.new(items).update_quality()
        GildedRose.new(items).update_quality()
        # then
        expect(items[0].quality).to eq(50)
      end
    end

    context "Sulfuras, Hand of Ragnaros" do
      # given
      items = [Item.new("Sulfuras, Hand of Ragnaros", 0, 80)]
      it 'la date de péremption ne change pas' do
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq(0)
      end
      it 'la qualité ne change pas' do
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq(80)
      end
    end
    
    context "Backstage passes to a TAFKAL80ETC concert" do
      # given
      context 'plus de 10 jours avant la date du concert' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 5)]
        GildedRose.new(items).update_quality()
        it 'la qualité augmente normalement' do
          expect(items[0].quality).to eq(6)
        end
      end

      context 'moins de 10 jours avant la date du concert' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 9, 5)]
        GildedRose.new(items).update_quality()
        it 'la qualité augmente de 2' do
          expect(items[0].quality).to eq(7)
        end
      end

      context 'moins de 5 jours avant la date du concert' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 5)]
        GildedRose.new(items).update_quality()
        it 'la qualité augmente de 3' do
          expect(items[0].quality).to eq(8)
        end
        it 'la qualité ne peut pas dépasser 50' do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 49)]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq(50)
        end
      end

      context 'après la date du concert' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 8)]
        GildedRose.new(items).update_quality()
        it 'la qualité retombe à 0' do
          expect(items[0].quality).to eq(0)
        end
      end
    end
  end

end
