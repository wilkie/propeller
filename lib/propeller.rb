require "propeller/version"
require "propeller/addon_manager"

module Propeller
  def self.configure(path)
    @@path = path
  end

  def self.require_from_main(path)
    basepath = @@path || "."
    path = "#{basepath}/#{path}"
  end

  def self.require_from_addon(addon_name, path)
    basepath = Gem::Specification::find_by_name(addon_name.to_s).gem_dir
    path = "#{basepath}/#{path}"
  end
end
