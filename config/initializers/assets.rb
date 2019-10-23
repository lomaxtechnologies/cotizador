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

# Javascript for the clients module
Rails.application.config.assets.precompile += %w( clients/index.js )

# Javascript for the services module
Rails.application.config.assets.precompile += %w( services/index.js )

# Javascript for the brands module
Rails.application.config.assets.precompile += %w( brands/index.js )

# Javascript for the materials module
Rails.application.config.assets.precompile += %w( materials/index.js )

# Javascript for the measure units module
Rails.application.config.assets.precompile += %w( measure_units/index.js )

# Javascript for the users module
Rails.application.config.assets.precompile += %w( users/registrations/index.js )
Rails.application.config.assets.precompile += %w( users/registrations/edit.js )
Rails.application.config.assets.precompile += %w( users/registrations/password_handler.js )

# Javascript for the prices module
Rails.application.config.assets.precompile += %w( products/index.js )

# Javascript for quotations module
Rails.application.config.assets.precompile += %w( quotations/quotations.js )

# Javascript for dashboards module
Rails.application.config.assets.precompile += %w( dashboards/dashboards.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
