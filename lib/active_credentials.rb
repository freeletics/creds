require "active_credentials/version"
require "active_credentials/plain_text"

require "active_support/core_ext/hash/keys" # Bug
require "active_support/core_ext/module/attribute_accessors" # Bug, needed for MessageEncryptor
require "active_support/encrypted_configuration"
require "active_support/ordered_options"
require "active_support/core_ext/module/delegation"

require "active_credentials/railtie"

class ActiveCredentials
  delegate_missing_to :configuration

  def initialize(file_path, env: nil, key_path: "config/master.key", env_key: "RAILS_MASTER_KEY", raise_if_missing_key: true)
    @file_path = file_path
    @env = env
    @key_path = key_path
    @env_key = env_key
    @raise_if_missing_key = raise_if_missing_key
  end

  def configuration
    @configuration ||= if @file_path.end_with?(".enc")
      ActiveSupport::EncryptedConfiguration.new(
        config_path: @file_path,
        key_path: @key_path,
        env_key: @env_key,
        raise_if_missing_key: @raise_if_missing_key
      )
    else
      ActiveSupport::OrderedOptions.new.tap do |options|
        options.config = ActiveCredentials::PlainText.new(@file_path, env: @env).config

        options.config.each do |key, value|
          options.send("#{key}=", value)
        end
      end
    end
  end
end
