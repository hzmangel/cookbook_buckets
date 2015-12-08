# Cookbook: saves cookbook data, and associate with Material and Tag
class Cookbook < ActiveRecord::Base
  has_many :materials
  has_and_belongs_to_many :tags

  validates :name, presence: true
  validates_associated :materials
  validates_associated :tags
end
