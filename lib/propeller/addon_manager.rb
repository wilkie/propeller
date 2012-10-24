module Propeller
  module AddonManager
    def self.register(mod)
      @@modules ||= []
      @@modules <<  mod
    end

    def self.modules
      @@modules
    end
  end
end
