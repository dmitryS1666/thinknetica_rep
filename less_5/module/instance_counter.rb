module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # Методы класса:
  # - instances, который возвращает кол-во экземпляров данного класса
  module ClassMethods
    attr_reader :instances

    private
    def add_instance
      puts 'add_instance class method'
      @instances ||= 0
      @instances += 1
    end

  end

  # Инастанс-методы:
  # register_instance:
  # - увеличивает счетчик кол-ва экземпляров класса
  # - можно вызвать из конструктора
  # При этом данный метод не должен быть публичным.
  module InstanceMethods
    protected
    def register_instance
      puts 'register_instance instances method'
      self.class.send(:add_instance)
    end


  end
end
