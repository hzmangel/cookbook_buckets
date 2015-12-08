class Cookbook < ActiveRecord::Base
  has_many :materials
  has_and_belongs_to_many :tags
end
