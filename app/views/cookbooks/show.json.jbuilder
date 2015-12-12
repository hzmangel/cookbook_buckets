json.call(@rcd, :id, :name, :image, :desc, :gdoc_url, :created_at, :updated_at)
json.tags @rcd.tags.each do |tag_r|
  # The key `text` is used for ngTagsInput
  json.text tag_r.name
end

json.materials @rcd.materials.each do |mat_r|
  json.call(mat_r, :id, :name, :quantity, :unit)
end
