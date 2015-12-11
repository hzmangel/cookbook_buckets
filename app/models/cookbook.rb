# Cookbook: saves cookbook data, and associate with Material and Tag
class Cookbook < ActiveRecord::Base
  has_many :materials, dependent: :destroy
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :materials, allow_destroy: true
  accepts_nested_attributes_for :tags

  validates :name, presence: true
  validates_associated :materials
  validates_associated :tags

  # tags_from_api is data passed from API side,
  # which is an array contains those data:
  # {text: 'tag_name'}
  def process_tags(tags_from_api)
    tag_names = tags_from_api.map { |r| r['text'] }
    update(tag_ids: tag_names.map do |r|
      Tag.find_or_create_by(name: r)
    end.map(&:id))
  end
end
