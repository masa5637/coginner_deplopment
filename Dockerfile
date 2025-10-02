# syntax=docker/dockerfile:1

FROM ruby:3.3.6-slim

# 作業ディレクトリ
WORKDIR /rails

# 必要パッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      libpq-dev \
      libvips-dev \
      libsass-dev \
      nodejs \
      npm \
      python-is-python3 && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Gemfile コピーと bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリコードをコピー
COPY . .

# bin ファイルの改行コードを LF に統一して実行権限付与
RUN sed -i 's/\r$//' bin/* && chmod +x bin/*

# JavaScript 依存関係をインストール
RUN yarn install --check-files

# アセットプリコンパイル
RUN SECRET_KEY_BASE=dummysecret123 \
    RAILS_ENV=production \
    bin/rails assets:precompile

# entrypoint.sh をコピーして実行権限を付与（rootユーザーで実行）
COPY entrypoint.sh /rails/entrypoint.sh
RUN chmod +x /rails/entrypoint.sh

# Rails 用非 root ユーザー作成（最後に実行）
RUN useradd -m rails && chown -R rails:rails /rails
USER rails

EXPOSE 3000

# エントリーポイントとして設定
ENTRYPOINT ["/rails/entrypoint.sh"]

# デフォルトコマンド
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]