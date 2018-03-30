# Based on http://api.rubyonrails.org/classes/Rails/Application.html#method-i-config_for
require "yaml"
require "erb"
require "pathname"
require "active_support/core_ext/hash/keys"
require "active_support/ordered_options"
require "active_support/core_ext/module/delegation"

class ActiveCredentials::PlainConfiguration
  delegate_missing_to :options

  def initialize(file_path, env:)
    @file = Pathname.new(file_path)
    @env = env
  end

  def config
    @config ||= (YAML.load(ERB.new(@file.read).result) || {}).fetch(@env, {}).deep_symbolize_keys
  end

  private

  def options
    @options ||= ActiveSupport::InheritableOptions.new(config)
  end
end
