require 'yaml'

require 'propeller/addon'
require 'propeller/configuration/section'
require 'propeller/configuration/option'

module Propeller
  class Blade
    attr_accessor :addons

    attr_accessor :sections

    def initialize(options = {})
      options = {:config_file => "config/blade.yml"}.merge(options)

      @yaml = load_yaml(options[:config_file])

      @addons = @yaml['addons'].map do |addon|
        addon.keys.each do |key|
          addon[(key.to_sym rescue key) || key] = addon.delete(key)
        end

        Propeller::Addon.new addon
      end

      @sections = @yaml['configuration'].map do |section|
        section.keys.each do |key|
          section[(key.to_sym rescue key) || key] = section.delete(key)
        end

        section[:options].map! do |option|
          option.keys.each do |key|
            option[(key.to_sym rescue key) || key] = option.delete(key)
          end

          option[:type] = option[:type].to_sym if option[:type]

          Propeller::Configuration::Option.new option
        end

        Propeller::Configuration::Section.new section
      end
    end

    private

    def load_yaml(config)
      YAML::load_file(config)
    end
  end
end
