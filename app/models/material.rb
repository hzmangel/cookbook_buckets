# Material, save materials name used in cookbook
class Material < ActiveRecord::Base
  has_many :material_quantities
  has_many :cookbooks, through: :material_quantities

  validates :name, presence: true
end
