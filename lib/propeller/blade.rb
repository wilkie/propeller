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
      options = {:config_file => "config/blade.yml",
                 :to_env      => true}.merge(options)

      @config_file = options[:config_file]
      @to_env      = options[:to_env]

      if ENV['blade_name']
        # We have loaded this stuff before,
        # Let's lazy load settings and addons
        #   (That is, do not open yaml file)
        @name   = ENV['blade_name']

        return
      end

      puts "Loading Main"
      yaml = YAML::load_file(options[:config_file])

      @name = yaml['name']

      @addons = load_addons(yaml)

      @sections = load_sections(yaml)

      if @to_env
        ENV['blade_name'] = @name
      end
    end

    def selection(options = {})
      @selection || load_selection(options)
    end

    def option(name)
      if ENV['blade_name']
        @sections ||= load_sections
      end

      section = @sections.select{|s| s.contains_option?(name)}.first

      unless section.nil?
        section.option(name)
      end
    end

    def addon_enabled?(addon)
      if ENV["blade_addon_#{addon.to_s}"]
        ENV["blade_addon_#{addon.to_s}"] == "true"
      else
        selection.addons_include? addon
      end
    end

    def user_option_for(name)
      if ENV["blade_setting_#{name.to_s}"]
        ENV["blade_setting_#{name.to_s}"]
      else
        selection[name]
      end
    end

    private

    def load_addons(yaml = nil)
      yaml ||= YAML::load_file(@config_file)

      @addons = yaml['addons'].map do |addon|
        addon.keys.each do |key|
          addon[(key.to_sym rescue key) || key] = addon.delete(key)
        end

        Propeller::Addon.new addon
      end
    end

    def load_sections(yaml = nil)
      yaml ||= YAML::load_file(@config_file)

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

    def load_selection(options = {})
      options = {:config_file => "config/blade.settings.yml",
                 :to_env      => true}.merge(options)

      if ENV['blade_addons']
      end

      if ENV['blade_setting']
      end

      puts "Loading Selection"
      yaml = YAML::load_file(options[:config_file])

      settings = []
      yaml['settings'] ||= []
      yaml['settings'].each do |key, value|
        name = key.to_sym
        option = option(name)
        settings << Propeller::Configuration::Setting.new(:option => option,
                                                          :value  => value)
      end

      addons = []
      yaml['addons'] ||= []
      if yaml['addons'].is_a? String
        yaml['addons'] = [yaml['addons']]
      end
      yaml['addons'].each do |key|
        addons << key.to_sym
      end

      @selection = Propeller::Selection.new addons, settings
    end
  end
end
