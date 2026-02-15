app_tags = [
  "個人制作",
  "チーム制作",
  "卒業制作",

  "日記",
  "業務効率化",
  "管理ツール",
  "診断",
  "ゲーム",
  "SNS",
  "AI",
  "API連携",
  "プロフィール",
  "ポートフォリオサイト"
]

article_tags = [
  "学習・習慣",
  "技術（Rails）",
  "技術（Git）",
  "技術（設計/ER）",
  "便利ツール",

  "個人開発",
  "チーム開発",

  "就活",
  "キャリア",
  "振り返り",
  "メンタル",

  "RUNTEQ生向け",
  "新入生向け",
  "初心者向け",
  "中級者向け",
  "上級者向け",

  "note",
  "Qiita",
  "Zenn"
]

# もし「両方に出したいタグ」が今後出たらここに入れる
both_tags = [
  # "おすすめ", "初心者向け"
]

app_tags.each do |name|
  tag = Tag.find_or_create_by!(name: name)
  tag.update!(kind: :app) if tag.kind != "app"
end

article_tags.each do |name|
  tag = Tag.find_or_create_by!(name: name)
  tag.update!(kind: :article) if tag.kind != "article"
end

both_tags.each do |name|
  tag = Tag.find_or_create_by!(name: name)
  tag.update!(kind: :both) if tag.kind != "both"
end

# --- Apps: YAML固定登録 ---
require "yaml"
require "date"

apps_yml_path = Rails.root.join("db", "seeds", "apps.yml")

if File.exist?(apps_yml_path)
  # Dateクラス等を読み込まない（安全） → YAML側は文字列運用
  apps_data = YAML.safe_load(File.read(apps_yml_path), permitted_classes: [], aliases: true) || []

  apps_data.each do |row|
    title = row["title"].to_s.strip
    next if title.blank?

    app = App.find_or_initialize_by(title: title)

    app.image_key    = row["image_key"].to_s.strip.presence
    app.summary      = row["summary"].to_s.strip.presence
    app.target       = row["target"].to_s.strip.presence
    app.tech         = row["tech"].to_s.strip.presence
    app.improvements = row["improvements"].to_s.strip.presence

    mvp = row["mvp_released_on"].to_s.strip.presence
    rel = row["released_on"].to_s.strip.presence

    app.mvp_released_on = mvp ? Date.parse(mvp) : nil
    app.released_on     = rel ? Date.parse(rel) : nil

    app.app_url   = row["app_url"].to_s.strip.presence
    app.demo_url  = row["demo_url"].to_s.strip.presence
    app.github_url = row["github_url"].to_s.strip.presence

    app.save!

    # tags
    tag_names = Array(row["tags"]).map { |t| t.to_s.strip }.reject(&:blank?)
    if app.respond_to?(:tags)
      app.tags = tag_names.map do |name|
        tag = Tag.find_or_create_by!(name: name)
        # 既存kindがあるなら尊重しつつ、アプリ用にしたいならここで app に寄せる
        tag.update!(kind: :app) if tag.kind != "app"
        tag
      end
    end
  end
else
  Rails.logger.info("[seed] db/seeds/apps.yml が無いため apps のseedはスキップしました")
end
