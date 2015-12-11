json.array! @rcds do |r|
  json.call(r, :id, :name, :image, :desc, :gdoc_url, :created_at, :updated_at)
  json.tags r.tags.each do |tag_r|
    # The key `text` is used for ngTagsInput
    json.text tag_r.name
  end
end
