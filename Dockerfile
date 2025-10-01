# syntax=docker/dockerfile:1

# --- Base image ---
FROM ruby:3.3.6-slim AS base

WORKDIR /rails

# Production 環境用
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# --- Build stage ---
FROM base AS build

# ビルドに必要なパッケージのみ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      libpq-dev \
      libvips \
      python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

# Gemfile をコピーして bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle && \
    bundle exec bootsnap precompile --gemfile

# アプリコードをコピー
COPY . .

# Assets precompile（Sprockets / CSSBundling 経由）
RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

# Bootsnap プリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# --- Runtime stage ---
FROM base

# ランタイムに必要なパッケージだけ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Build stage から gems とアプリをコピー
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# 非 root ユーザー作成
RUN useradd -m rails && \
    chown -R rails:rails db log storage tmp

USER rails

# Entrypoint & サーバー起動
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
