# Cookbook: saves cookbook data, and associate with Material and Tag
class Cookbook < ActiveRecord::Base
  has_many :materials, dependent: :destroy
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :materials, allow_destroy: true
  accepts_nested_attributes_for :tags

  validates :name, presence: true
  validates_associated :materials
  validates_associated :tags
end
