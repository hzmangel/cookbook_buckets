# Material, save materials used in cookbook
class Material < ActiveRecord::Base
  belongs_to :cookbook

  validates :name, presence: true
  validates :quality, numericality: { only_integer: true, greater_than: 0 }
  validates :unit, presence: true
end
