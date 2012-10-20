module Propeller
  class Selection
    def initialize(addons, settings)
      @addons = addons

      @settings = {}

      settings.each do |setting|
        @settings[setting.option.name.to_sym] = setting
      end
    end

    def addons_include?(addon)
      @addons.include? addon
    end

    def option(name)
      @settings[name].option
    end

    def [](name)
      @settings[name].value
    end

    def to_yaml
      ret = ""

      unless @addons.empty?
        ret << "addons:\n  "
        ret << @addons.map(&:to_json).join("\n  ")
        ret << "\n"
      end

      unless @settings.empty?
        ret << "settings:\n  "
        ret << @settings.values.map(&:to_json).join("\n  ") 
        ret << "\n"
      end

      ret.chomp
    end

    def to_json
      ret = "{\n  "
      ret << @settings.values.map(&:to_json).join(",\n  ") 
      ret << "\n}"
    end

    def to_s
      to_yaml
    end
  end
end
