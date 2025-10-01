# syntax=docker/dockerfile:1

# Ruby バージョンを指定
ARG RUBY_VERSION=3.3.6
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# 本番環境用設定
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

# Build 用ステージ
FROM base AS build

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    nodejs \
    npm && \
    npm install -g sass && \
    rm -rf /var/lib/apt/lists/*

# Gemfile をコピーして bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# アプリケーションコードをコピー
COPY . .

# Sass で CSS をビルド
RUN sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map

# Bootsnap 用のプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# Final イメージ
FROM base

# ランタイムに必要なパッケージだけ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# ビルド済みアプリと Gems をコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# 非 root ユーザーを作成
RUN useradd -m rails && \
    chown -R rails:rails db log storage tmp

USER rails

# Entrypoint とサーバー起動
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
