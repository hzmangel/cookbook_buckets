class AddMaterialToCookbook < ActiveRecord::Migration
  def change
    add_reference :materials, :cookbook, index: true, foreign_key: true
  end
end
