module Propeller
  class Selection
    def initialize(settings)
      @settings = {}

      settings.each do |setting|
        @settings[setting.option.name.to_sym] = setting
      end
    end

    def [](name)
      @settings[name]
    end

    def to_yaml
      @settings.values.map(&:to_json).join("\n") 
    end

    def to_json
      ret = "{\n  "
      ret << @settings.values.map(&:to_json).join(",\n  ") 
      ret << "\n}"
    end

    def to_s
      @settings.values.map(&:to_s).join("\n")
    end
  end
end
