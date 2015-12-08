class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :quality
      t.string :unit

      t.timestamps null: false
    end
  end
end
