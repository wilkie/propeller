require 'propeller/addon'
require 'propeller/configuration/section'
require 'propeller/configuration/option'
require 'propeller/selection'

module Propeller
  class Blade
    require 'yaml'

    attr_accessor :name
    attr_accessor :addons
    attr_accessor :sections

    def initialize(options = {})
      options = {:config_file => "config/blade.yml"}.merge(options)

      yaml = YAML::load_file(options[:config_file])

      @name = yaml['name']

      @addons = yaml['addons'].map do |addon|
        addon.keys.each do |key|
          addon[(key.to_sym rescue key) || key] = addon.delete(key)
        end

        Propeller::Addon.new addon
      end

      @sections = yaml['configuration'].map do |section|
        section.keys.each do |key|
          section[(key.to_sym rescue key) || key] = section.delete(key)
        end

        section[:options].map! do |option|
          option.keys.each do |key|
            option[(key.to_sym rescue key) || key] = option.delete(key)
          end

          option[:type] = option[:type].to_sym if option[:type]
          option[:name] = option[:name].to_sym if option[:name]

          Propeller::Configuration::Option.new option
        end

        Propeller::Configuration::Section.new section
      end
    end

    def selection(options = {})
      @selection || load_selection(options)
    end

    def option(name)
      section = @sections.select{|s| s.contains_option?(name)}.first

      unless section.nil?
        section.option(name)
      end
    end

    private

    def load_selection(options = {})
      options = {:config_file => "config/blade.settings.yml"}.merge(options)

      yaml = YAML::load_file(options[:config_file])

      settings = []
      yaml.each do |key, value|
        name = key.to_sym
        option = option(name)
        settings << Propeller::Configuration::Setting.new(:option => option,
                                                          :value  => value)
      end

      @selection = Propeller::Selection.new settings
    end
  end
end
