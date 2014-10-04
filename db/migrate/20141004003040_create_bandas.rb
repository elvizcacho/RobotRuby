class CreateBandas < ActiveRecord::Migration
  def change
    create_table :bandas do |t|
      t.string :nombre
      t.integer :likes
      t.integer :spotify
      t.integer :lastfm

      t.timestamps
    end
  end
end
