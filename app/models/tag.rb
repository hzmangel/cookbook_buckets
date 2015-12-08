# Tag: Classify cookbook record
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :cookbooks

  validates :name, presence: true
end
