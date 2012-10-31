require "propeller/version"
require "propeller/addon_manager"

module Propeller
  def self.configure(options)
    @@path = options[:path]
  end

  def self.path_for_main
    @@path ||= "."
  end

  def self.require_from_main(path)
    require "#{Propeller.path_for_main}/#{path}"
  end

  def self.path_for(addon_name)
    Gem::Specification::find_by_name(addon_name.to_s).gem_dir
  end

  def self.require_from(addon_name, path)
    require "#{Propeller.path_for(addon_name)}/#{path}"
  end

  def self.rake_files(query)
    addon_tests = []
    blade = Propeller::Blade.new(:to_env => false)
    blade.selection.addons.each do |addon|
      search = File.join(Propeller.path_for(addon), query)
      addon_tests.concat(Dir.glob(search))
    end
    addon_tests
  end
end

def require_from_main(path)
  Propeller.require_from_main path
end

def require_from(addon_name, path)
  Propeller.require_from addon_name, path
end
