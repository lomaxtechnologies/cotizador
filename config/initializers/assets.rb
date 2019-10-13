# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.precompile += %w( i18n.js )

# Utils files for modals, inline forms and paging
Rails.application.config.assets.precompile += %w( utils/confirmation_modal.js )
Rails.application.config.assets.precompile += %w( utils/inline_form_handler.js )
Rails.application.config.assets.precompile += %w( utils/paging_handler.js )

Rails.application.config.assets.precompile += %w( clients/index.js )
# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
