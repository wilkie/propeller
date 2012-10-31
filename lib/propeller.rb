require "propeller/version"
require "propeller/addon_manager"

module Propeller
  def self.configure(options)
    @@path = options[:path]
  end

  def self.require_from_main(path)
    @@path ||= "."
    path = "#{@@path}/#{path}"
  end

  def self.require_from_addon(addon_name, path)
    basepath = Gem::Specification::find_by_name(addon_name.to_s).gem_dir
    path = "#{basepath}/#{path}"
  end
end
