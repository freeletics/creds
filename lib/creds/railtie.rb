require "rails/railtie"

class Creds::Railtie < Rails::Railtie
  # Secret key base is required in Rails.
  # By default it is taken from one of: env variable, credentials or secrets with fallback
  # to config which is set here if present.
  initializer "creds.set_secret_key_base", before: :load_config_initializers do
    if config.respond_to?(:creds) && config.creds.secret_key_base
      Rails.configuration.secret_key_base ||= config.creds.secret_key_base
    end
  end
end
