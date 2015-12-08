class CookbooksTags < ActiveRecord::Migration
  def change
    create_table :cookbooks_tags, id: false do |t|
      t.belongs_to :cookbook, index: true
      t.belongs_to :tag, index: true
    end
  end
end
