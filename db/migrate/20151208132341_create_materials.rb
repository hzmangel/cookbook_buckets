class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name

      t.timestamps

      t.index :name
    end
  end
end
