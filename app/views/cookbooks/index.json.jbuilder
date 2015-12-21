json.array! @cookbooks do |r|
  json.call(r, :id, :name, :image, :desc, :gdoc_url, :created_at, :updated_at)
  json.tags r.tags.each do |tag_r|
    # The key `text` is used for ngTagsInput
    json.text tag_r.name
  end

  json.materials r.material_quantities.each do |mat_r|
    next if mat_r.material.nil?
    json.id mat_r.material_id
    json.name mat_r.material.name
    json.call(mat_r, :quantity, :unit)
  end
end
