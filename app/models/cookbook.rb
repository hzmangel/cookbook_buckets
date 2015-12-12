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
    return if tags_from_api.nil?
    tag_names = tags_from_api.map { |r| r['text'] }
    update(tag_ids: tag_names.map do |r|
      Tag.find_or_create_by(name: r)
    end.map(&:id))
  end

  # materials_from_api is data passed from API side,
  # which is an array contains those data:
  # {
  #   id: 'id or fake id',
  #   name: 'material name',
  #   quantity: material quantity (numeric),
  #   unit: 'material unit'
  #   _destroy: true (when removing)
  # }
  def process_materials(materials_from_api)
    return if materials_from_api.nil?
    destroy_ids = []

    materials_from_api.each do |r|
      if r[:_destroy].present?
        destroy_ids << r[:id]
      else
        material_params = {
          name: r[:name],
          quantity: r[:quantity],
          unit: r[:unit]
        }

        # Change id to integer to match MySQL
        if material_ids.include?(r[:id].to_i)
          # Existing record
          materials.find(r[:id]).update(material_params)
        else
          # New material record
          materials.create(material_params)
        end
      end
    end

    materials.where(id: destroy_ids).destroy_all if destroy_ids.present?
  end
end
