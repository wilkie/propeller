require 'yaml'

require 'propeller/addon'

module Propeller
  class Blade
    attr_accessor :addons

    def initialize(options = {})
      options = {:config_file => "config/blade.yml"}.merge(options)

      @yaml = load_yaml(options[:config_file])

      @addons = @yaml['addons'].map do |addon|
        addon.keys.each do |key|
          addon[(key.to_sym rescue key) || key] = addon.delete(key)
        end

        Propeller::Addon.new addon
      end
    end

    private

    def load_yaml(config)
      YAML::load_file(config)
    end
  end
end
