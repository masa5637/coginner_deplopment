# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# bootstrap-icons gem のパス（gemが読み込まれている場合のみ）
if defined?(BootstrapIcons)
  Rails.application.config.assets.paths << BootstrapIcons.assets_path
else
  Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "stylesheets")
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )