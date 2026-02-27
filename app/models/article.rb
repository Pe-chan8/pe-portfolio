class Article < ApplicationRecord
  attr_reader :id, :title, :summary, :body, :published_on, :url, :source, :tags, :description

  DATA_PATH = Rails.root.join("config/data/articles.yml")

  def initialize(attrs)
    attrs = attrs.symbolize_keys

    @id = attrs.fetch(:id)
    @title = attrs[:title]
    @summary = attrs[:summary]
    @body = attrs[:body]
    @url = attrs[:url]
    @source = attrs[:source]
    @tags = Array(attrs[:tags]).compact
    @description = attrs[:description]

    @published_on =
      attrs[:published_on].present? ? Date.parse(attrs[:published_on].to_s) : nil
  end

  def to_param = id.to_s

  class << self
    def all
      load_all
    end

    def find(id)
      all.find { |a| a.id.to_s == id.to_s } || raise(ActionController::RoutingError, "Not Found")
    end

    def search(keyword)
      return all if keyword.blank?

      kw = keyword.to_s.downcase
      all.select do |a|
        [ a.title, a.summary, a.body ].compact.join(" ").downcase.include?(kw)
      end
    end

    def sort(list, sort_key)
      case sort_key
      when "published_on_asc"
        list.sort_by { |a| a.published_on || Date.new(1900, 1, 1) }
      when "title_asc"
        list.sort_by { |a| a.title.to_s }
      when "title_desc"
        list.sort_by { |a| a.title.to_s }.reverse
      else # published_on_desc default
        list.sort_by { |a| a.published_on || Date.new(1900, 1, 1) }.reverse
      end
    end

    private

    def load_all
      raw = YAML.safe_load(File.read(DATA_PATH), permitted_classes: [], aliases: true) || []
      raw.map { |h| new(h) }
    end
  end
end
