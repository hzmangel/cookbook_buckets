# Material, save materials used in cookbook
class MaterialQuantity < ActiveRecord::Base
  belongs_to :cookbook
  belongs_to :material

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit, presence: true
end
