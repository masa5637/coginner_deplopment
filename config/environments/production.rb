require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # コードはリクエスト間で再読み込みしない
  config.enable_reloading = false

  # 起動時にコードを eager load
  config.eager_load = true

  # エラー画面を表示せず、キャッシュを有効
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # マスターキーの使用（必要であればコメントを外す）
  # config.require_master_key = true

  # 静的ファイルはサーバーに任せる（NGINX/Apacheなど）
  # config.public_file_server.enabled = false

  # CSS圧縮はsassでOK
  # config.assets.css_compressor = :sass

  # プリコンパイルされていないアセットにフォールバックしない
  config.assets.compile = false

  # アセットプリコンパイル時にRailsを初期化しない
  config.assets.initialize_on_precompile = false

  # アセットサーバーの設定（必要であれば）
  # config.asset_host = "http://assets.example.com"

  # X-Sendfileヘッダ（NGINX/Apacheで使用）
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # NGINX

  # Active Storageはローカル
  config.active_storage.service = :local

  # SSLを強制
  config.force_ssl = true

  # ログをSTDOUTに出力
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # リクエストIDでログをタグ付け
  config.log_tags = [:request_id]

  # ログレベル
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # キャッシュストア（必要に応じて設定）
  # config.cache_store = :mem_cache_store

  # Active Jobの設定（必要に応じて）
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "coginner_deplopment_production"

  config.action_mailer.perform_caching = false

  # I18nフォールバック
  config.i18n.fallbacks = true

  # 非推奨通知をログに出さない
  config.active_support.report_deprecations = false

  # マイグレーション後にスキーマをダンプしない
  config.active_record.dump_schema_after_migration = false

  # ホスト制限（Renderなどに対応）
  config.hosts << /.*\.onrender\.com/
  config.hosts.clear

  # JS圧縮は esbuild に任せるのでUglifierは不要
  config.assets.js_compressor = nil
end
