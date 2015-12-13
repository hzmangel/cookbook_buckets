class AddGdocIdToCookbooks < ActiveRecord::Migration
  def change
    add_column :cookbooks, :gdoc_id, :string
  end
end
