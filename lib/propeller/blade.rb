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
    attr_accessor :addon_sections

    def initialize(options = {})
      options = {:config_file => "config/blade.yml",
                 :to_env      => true}.merge(options)

      @config_file = options[:config_file]
      @to_env      = options[:to_env]

      if ENV['blade_name'] && @to_env
        # We have loaded this stuff before,
        # Let's lazy load settings and addons
        #   (That is, do not open yaml file)
        @name = ENV['blade_name']

        return
      end

      yaml = YAML::load_file(options[:config_file]) || {}

      @name = yaml['name']

      @addons = load_addons(yaml)

      @sections = load_sections(yaml)

      @addon_sections = load_all_addon_sections

      if @to_env
        ENV['blade_name'] = @name
      end
    end

    def selection(options = {})
      @selection ||= load_selection(options)
    end

    def option(name)
      if ENV['blade_name'] && @to_env
        @sections ||= load_sections
      end

      all_sections = @sections
      @addon_sections.values.each do |sections|
        all_sections.concat(sections)
      end

      sections = all_sections.select{|s| s.contains_option?(name)}
      if sections.empty?
        return nil
      end

      section = sections.first

      unless section.nil?
        section.option(name)
      end
    end

    def addon_enabled?(addon)
      if ENV["blade_addon_#{addon.to_s}"] && @to_env
        ENV["blade_addon_#{addon.to_s}"] == "true"
      else
        selection.addons_include? addon
      end
    end

    def user_option_for(name)
      if ENV["blade_setting_#{name.to_s}"] && @to_env
        ENV["blade_setting_#{name.to_s}"]
      else
        selection[name]
      end
    end

    private

    def load_addons(yaml = nil)
      yaml ||= YAML::load_file(@config_file) || {}

      yaml['addons'] ||= []
      @addons = yaml['addons'].map do |addon|
        addon.keys.each do |key|
          addon[(key.to_sym rescue key) || key] = addon.delete(key)
        end

        addon[:name] = addon[:name].to_sym

        Propeller::Addon.new addon
      end
    end

    def load_sections(yaml = nil)
      yaml ||= YAML::load_file(@config_file) || {}

      yaml['configuration'] ||= []
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

    def load_all_addon_sections
      @addon_sections ||= {}
      @addons ||= load_addons
      @addons.each do |a|
        @addon_sections[a.name] ||= load_addon_sections(a) if a.blade_exists?
      end
      @addon_sections
    end

    def load_addon_sections(addon)
      addon.blade.sections if addon.blade_exists?
    end

    def load_selection(options = {})
      options = {:config_file => "config/blade.settings.yml",
                 :to_env      => true}.merge(options)

      if ENV['blade_addons']
      end

      if ENV['blade_setting']
      end

      # reload addon sections
      load_all_addon_sections

      settings = []
      addons = []
      if File.exists? options[:config_file]
        yaml = YAML::load_file(options[:config_file])
      else
        yaml = {}
      end

      yaml['settings'] ||= []
      yaml['settings'].each do |key, value|
        name = key.to_sym
        option = option(name)
        settings << Propeller::Configuration::Setting.new(:option => option,
                                                          :value  => value)
      end

      yaml['addons'] ||= []
      if yaml['addons'].is_a? String
        yaml['addons'] = [yaml['addons']]
      end
      yaml['addons'].each do |key|
        addons << key.to_sym
      end

      all_sections = @sections
      @addon_sections.values.each do |sections|
        all_sections.concat(sections)
      end

      all_sections.each do |section|
        section.options.each do |option|
          unless settings.any?{|s| s.option.name == option.name}
            settings << Propeller::Configuration::Setting.new(:option => option,
                                                              :value  => option.default)
          end
        end
      end

      @selection = Propeller::Selection.new addons, settings
    end
  end
end
