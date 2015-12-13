class CreateCookbooks < ActiveRecord::Migration
  def change
    create_table :cookbooks do |t|
      t.string :name
      t.string :image
      t.string :desc
      t.string :gdoc_url

      t.timestamps

      t.index :name
      t.index :desc
    end
  end
end
