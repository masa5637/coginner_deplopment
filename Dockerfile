FROM ruby:3.3.6-slim

WORKDIR /rails

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

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN sed -i 's/\r$//' bin/* && chmod +x bin/*

RUN yarn install --check-files
RUN yarn build

RUN SECRET_KEY_BASE=dummysecret123 RAILS_ENV=production bin/rails assets:precompile

COPY entrypoint.sh /rails/entrypoint.sh
RUN chmod +x /rails/entrypoint.sh

RUN useradd -m rails && chown -R rails:rails /rails
USER rails

EXPOSE 3000
ENTRYPOINT ["/rails/entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
