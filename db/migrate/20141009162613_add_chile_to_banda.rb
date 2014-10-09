class AddChileToBanda < ActiveRecord::Migration
  def change
    add_column :bandas, :chile, :integer
  end
end
