# syntax=docker/dockerfile:1
FROM ruby:3.3.6

# 必要パッケージ
RUN apt-get update -y && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  npm \
  git \
  && rm -rf /var/lib/apt/lists/*

# Yarn
RUN npm install -g yarn

WORKDIR /app

# 先にGemだけ入れてキャッシュ効かせる
COPY Gemfile Gemfile.lock ./
RUN bundle install

# JS依存
COPY package.json ./
RUN yarn install

# アプリ本体
COPY . .

# entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
