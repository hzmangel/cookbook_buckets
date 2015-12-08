class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :quantity
      t.string :unit

      t.timestamps
    end
  end
end
