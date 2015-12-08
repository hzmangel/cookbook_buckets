class AddMaterialToCookbook < ActiveRecord::Migration
  def change
    add_reference :cookbooks, :material, index: true, foreign_key: true
  end
end
