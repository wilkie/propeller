require 'propeller/configuration/setting'

module Propeller
  module Configuration
    class Option
      attr_accessor :name
      attr_accessor :description
      attr_accessor :type

      def initialize(option_hash)
        @name        = option_hash[:name]
        @description = option_hash[:description]
        @type        = option_hash[:type]
        @if          = option_hash[:if]
        @default     = option_hash[:default]
      end

      def default
        default_value = @default || case @type
                                    when :bool
                                      false
                                    when :string
                                      ""
                                    when :integer, :decimal
                                      0
                                    end

        Setting.new(:option => self,
                    :value  => default_value)
      end
    end
  end
end
