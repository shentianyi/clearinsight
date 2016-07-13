require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clearinsight
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    self.paths["config/database"] = "config/database_mac.yml" if /darwin\w+/.match(RbConfig::CONFIG['host_os'])

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths+=%W(#{config.root}/base)
    config.autoload_paths+=Dir[Rails.root.join('app','models','{**}')]

    config.i18n.default_locale = "zh"
  end
end
