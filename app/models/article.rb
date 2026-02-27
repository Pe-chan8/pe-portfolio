class Article
  ArticleItem = Struct.new(
    :id, :title, :url, :source, :tags, :published_on, :description, :image_url, :status,
    keyword_init: true
  )

  DATA_PATH = Rails.root.join("db", "data", "articles.yml")

  def self.all
    load_items
  end

  def self.public_items
    load_items.select { |a| a.status.to_s == "public" }
  end

  def self.load_items
    rows = load_yaml
    rows.map { |row| ArticleItem.new(**normalize(row)) }
        .sort_by { |a| a.published_on.to_s }
        .reverse
  end

  def self.load_yaml
    return [] unless File.exist?(DATA_PATH)

    yaml = File.read(DATA_PATH)
    YAML.safe_load(yaml, permitted_classes: [], aliases: true) || []
  end

  def self.normalize(row)
    row = (row || {}).transform_keys(&:to_s)

    {
      id: row["id"],
      title: row["title"],
      url: row["url"],
      source: row["source"],
      tags: row["tags"] || [],
      published_on: row["published_on"],
      description: row["description"],
      image_url: row["image_url"],
      status: row["status"] || "public"
    }
  end
end
