class AddMaterialToCookbook < ActiveRecord::Migration
  def change
    create_table :material_quantities do |t|
      t.belongs_to :material, index: true
      t.belongs_to :cookbook, index: true

      t.string :unit
      t.integer :quantity
      t.timestamps null: false
    end
  end
end
