
books_rows = Book.load_books_yaml
books_rows.each do |row|
  attrs = Book.normalize_books_yaml(row)

  book = if attrs[:google_books_id].present?
    Book.find_or_initialize_by(google_books_id: attrs[:google_books_id])
  else
    # google_books_idが無い場合は title + read_on で擬似一意
    Book.find_or_initialize_by(title: attrs[:title], read_on: attrs[:read_on])
  end

  book.assign_attributes(attrs)
  book.save!

  # tags（あれば）
  tags = (row["tags"] || []).map(&:to_s)
  tags.each do |tag_name|
    tag = Tag.find_or_create_by!(name: tag_name)
    Tagging.find_or_create_by!(tag: tag, taggable: book)
  end
end
