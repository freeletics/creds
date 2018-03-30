require "rails/railtie"

class ActiveCredentials::Railtie < Rails::Railtie
  # Secret key base is required in Rails.
  # By default it is taken from one of: env variable, credentials or secrets with fallback
  # to config which is set here if present.
  initializer "active_credentials.set_secret_key_base", before: :load_config_initializers do
    if config.respond_to?(:active_credentials) && config.active_credentials.secret_key_base
      config.secret_key_base = config.active_credentials.secret_key_base
    end
  end
end
