tag_names = [
  "卒業制作",
  "個人制作アプリ",
  "チーム制作アプリ",
  "CGM（ユーザー投稿型）",
  "メディア系",
  "業務・便利ツール系",
  "診断系",
  "ゲーム系",
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

tag_names.each do |name|
  Tag.find_or_create_by!(name: name)
end
