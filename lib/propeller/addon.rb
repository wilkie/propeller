module Propeller
  class Addon
    require 'git'
    require 'uri'
    require 'fileutils'

    attr_accessor :name
    attr_accessor :git
    attr_accessor :description

    def initialize(addon_hash)
      @name        = addon_hash[:name]
      @git         = addon_hash[:git]
      @description = addon_hash[:description]

      @downloaded  = false
      @copied      = false
    end

    def blade
      copy_blade

      @blade ||= Propeller::Blade.new(:config_file => ".addons/.blades/#{@name}.yml",
                                      :to_env      => false)
    end

    def blade_exists?
      @copied = File.exists? ".addons/.blades/#{@name}.yml"
    end

    def install
      download
    end

    private

    def download
      return if @downloaded

      FileUtils.mkdir_p ".addons"

      @git.each do |path|
        begin
          # TODO : detect that it has been downloaded and pull latest
          g = Git.clone(URI(path), ".addons/#{@name}")
          @downloaded = true

          break
        rescue Git::GitExecuteError => e
          puts "Error retrieving repository... trying to find another mirror."
        end
      end
    end

    def delete
      FileUtils.rm_rf ".addons/#{@name}"
      @downloaded = false
    end

    def copy_blade
      download unless blade_exists?
      return if blade_exists?

      FileUtils.mkdir_p ".addons/.blades"
      if File.exists? ".addons/#{@name}/config/blade.yml"
        FileUtils.cp ".addons/#{@name}/config/blade.yml", ".addons/.blades/#{@name}.yml"
      end

      @copied = true
      delete
    end
  end
end
