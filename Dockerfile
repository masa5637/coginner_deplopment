FROM ruby:3.3.6-slim

# 作業ディレクトリ
WORKDIR /rails

# 必要パッケージのインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      libpq-dev \
      libvips-dev \
      nodejs \
      npm \
      python-is-python3 && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Gemfile をコピーして bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# アプリケーションをコピー
COPY . .

# bin/* を実行可能に
RUN sed -i 's/\r$//' bin/* && chmod +x bin/*

# Yarn で JS パッケージをインストール
RUN yarn install --check-files

# assets precompile（RAILS_ENV=production）
RUN SECRET_KEY_BASE=dummysecret123 RAILS_ENV=production bin/rails assets:precompile

# entrypoint をセット
COPY entrypoint.sh /rails/entrypoint.sh
RUN chmod +x /rails/entrypoint.sh

# 非特権ユーザー作成
RUN useradd -m rails && chown -R rails:rails /rails
USER rails

EXPOSE 3000

ENTRYPOINT ["/rails/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
