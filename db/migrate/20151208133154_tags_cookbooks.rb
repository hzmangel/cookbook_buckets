class TagsCookbooks < ActiveRecord::Migration
  def change
    create_table :tags_cookbooks do |t|
      t.belongs_to :cookbook, index: true
      t.belongs_to :tag, index: true
    end
  end
end
