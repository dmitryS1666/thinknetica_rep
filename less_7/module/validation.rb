module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validate_rule

    def validate(name, type_valid, *args)
      @validate_rule ||= []
      @validate_rule << { name: name, type_valid: type_valid, args: args }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue ArgumentError
      false
    end

    protected

    def validate!
      validate_params =
          if self.class.validate_rule.nil?
            []
          else
            self.class.validate_rule
          end

      validate_params.each do |params|
        name = instance_variable_get("@#{params[:name]}")
        send params[:type_valid], name, *params[:args]
      end
    end

    def presence(param)
      raise ArgumentError, 'Параметр не может быть пустым' if param.nil? || param.empty?
    end

    def type(param, type)
      raise ArgumentError, 'Не правильный тип' if param.class != type
    end

    def format(param, regexp)
      raise ArgumentError, 'Не правильный формат' if param !~ regexp
    end
  end
end
