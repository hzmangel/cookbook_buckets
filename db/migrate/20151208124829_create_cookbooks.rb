class CreateCookbooks < ActiveRecord::Migration
  def change
    create_table :cookbooks do |t|
      t.string :name
      t.string :image
      t.string :desc

      t.timestamps

      t.index :name
    end
  end
end