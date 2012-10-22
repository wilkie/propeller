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

      @downloaded = false
    end

    def blade
      download

      @blade ||= Propeller::Blade.new(:config_file => ".addons/#{@name}/config/blade.yml",
                                      :to_env      => false)
    end

    private

    def download
      return if @downloaded

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

    def install
      download
    end
  end
end
