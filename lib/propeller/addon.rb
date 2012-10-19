module Propeller
  class Addon
    attr_accessor :name
    attr_accessor :git
    attr_accessor :description

    def initialize(addon_hash)
      @name        = addon_hash[:name]
      @git         = addon_hash[:git]
      @description = addon_hash[:description]
    end
  end
end
