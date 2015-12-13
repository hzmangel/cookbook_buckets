# Cookbook: saves cookbook data, and associate with Material and Tag
class Cookbook < ActiveRecord::Base
  has_many :materials, dependent: :destroy
  has_and_belongs_to_many :tags

  has_many :material_quantities
  has_many :materials, through: :material_quantities
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
          name: r[:name]
        }

        quantity_params = {
          quantity: r[:quantity],
          unit: r[:unit]
        }

        # Change id to integer to match MySQL
        if material_ids.include?(r[:id].to_i)
          # Existing id, but may need new record
          material = materials.find(r[:id])
          if material.name != r[:name]
            new_material = materials.find_or_initialize_by(material_params)
            material_quantities.find_by(material_id: r[:id]).update(material_id: new_material.id)
            new_material.save
          else
            material_quantities.find_by(material_id: r[:id]).update(quantity_params)
          end
        else
          # Possible new material record
          new_material = Material.find_or_initialize_by(material_params)
          material_quantities.create(quantity_params.merge(material: new_material))
          new_material.save
        end
      end
    end

    material_quantities.where(material_id: destroy_ids).destroy_all if destroy_ids.present?
  end

  def google_drive
    @drive ||= auth_google_drive
  end

  def auth_google_drive
    ENV['GOOGLE_APPLICATION_CREDENTIALS'] = Rails.root.join('config', 'credential.json').to_s
    @drive = Google::Apis::DriveV2::DriveService.new
    @drive.authorization = Google::Auth.get_application_default([Drive::AUTH_DRIVE])
    @drive
  end

  def sync_gsheet
    if gdoc_id.nil?
      # Create new sheet
      file = google_drive.insert_file(
        {
          title: "Cookbook-#{Time.now.strftime('%Y%m%d-%H%M%S')}"
        }, upload_source: __FILE__)
      puts "Created file #{file.title} (#{file.id})"
      update(gdoc_id: file.id)
    else
      # TODO: Update existing sheet
      puts "Created file #{file.title} (#{file.id})"
    end
  end
end
