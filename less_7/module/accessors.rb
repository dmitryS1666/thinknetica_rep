module Accessors
  def attr_accessor_with_history(*args)
    args.each do |arg|
      history_array = []
      prepared_arg = "@#{arg}".to_sym
      define_method(arg) { instance_variable_get(prepared_arg) }
      define_method("#{arg}=".to_sym) do |val|
        instance_variable_set(prepared_arg, val)
        history_array << val
      end
      define_method("#{arg}_history") { history_array }
    end
  end

  def strong_attr_accessor(arg, class_arg)
    prepared_arg = "@#{arg}".to_sym
    define_method(arg) { instance_variable_get(prepared_arg) }
    define_method("#{arg}=".to_sym) do |val|
      if arg.is_a? class_arg
        instance_variable_set(prepared_arg, val)
      else
        raise ArgumentError, 'Не совпадают типы'
      end
    end
  end
end
