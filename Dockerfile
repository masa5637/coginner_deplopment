# syntax=docker/dockerfile:1
ARG RUBY_VERSION=3.3.6
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

# 作業ディレクトリ
WORKDIR /rails

# 必要なパッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev nodejs yarn libvips pkg-config curl && \
    rm -rf /var/lib/apt/lists/*

# Rails をインストール
RUN gem install rails -v 7.1

# Bundler インストール
RUN gem install bundler

# ホストのコードをコピー
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# bin フォルダの調整（Windows → Linux 改行）
RUN chmod +x bin/* && \
    sed -i "s/\r$//g" bin/* && \
    sed -i 's/ruby\.exe$/ruby/' bin/*

# 非 root ユーザー作成
RUN useradd -m rails && chown -R rails:rails /rails
USER rails

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
