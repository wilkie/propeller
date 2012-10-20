require 'propeller/configuration/setting'

module Propeller
  module Configuration
    class Option
      attr_accessor :name
      attr_accessor :description
      attr_accessor :type
      attr_accessor :default
      attr_accessor :min
      attr_accessor :max

      def initialize(option_hash)
        @name        = option_hash[:name]
        @description = option_hash[:description]
        @type        = option_hash[:type]
        @if          = option_hash[:if]
        @min         = option_hash[:min]
        @max         = option_hash[:max]
        @default     = option_hash[:default] || case @type
                                                when :bool
                                                  false
                                                when :string
                                                  ""
                                                when :integer, :decimal
                                                  0
                                                end
      end
    end
  end
end
