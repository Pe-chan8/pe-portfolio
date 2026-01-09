app_tags = [
  "卒業制作",
  "個人制作アプリ",
  "チーム制作アプリ",
  "CGM（ユーザー投稿型）",
  "メディア系",
  "業務・便利ツール系",
  "診断系",
  "ゲーム系"
]

article_tags = [
  "自己アウトプット",
  "就活",
  "特に新入生におすすめ",
  "振り返り",
  "チーム開発日記",
  "技術記事",
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
