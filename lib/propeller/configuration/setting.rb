module Propeller
  module Configuration
    class Setting
      attr_accessor :option
      attr_accessor :value

      def initialize(value_hash)
        @option = value_hash[:option]
        @value  = value_hash[:value]
      end

      def to_s
        "[#{@option.name}] => #{@value}"
      end
    end
  end
end
