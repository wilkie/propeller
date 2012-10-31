module Propeller
  module AddonManager
    def self.register(name, mod)
      @@modules ||= {}
      @@modules[name] = mod
    end

    def self.modules
      @@modules ||= {}
    end

    def self.module_for(addon)
      @@modules ||= {}
      @@modules[addon]
    end
  end
end
