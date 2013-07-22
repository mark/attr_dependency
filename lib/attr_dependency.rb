module AttrDependency

  def attr_dependency(attribute, options = {}, &default)
    attribute_factory_ivar = "@__#{attribute}_block__"
    operator               = options[:memoize] ? "||=" : "="

    instance_variable_set(attribute_factory_ivar, default)

    class_eval <<-END
      def self.#{attribute}(*args, &new_default)
        if block_given?
          #{ attribute_factory_ivar } = new_default
        end

        #{ attribute_factory_ivar }.(*args)
      end

      def #{attribute}(*args)
        @#{attribute} #{operator} self.class.#{attribute}(*args)
      end
    END
  end

  def with_dependencies(temporary_dependencies)
    current_dependencies = setup_dependencies(temporary_dependencies)
    yield
    setup_dependencies(current_dependencies)
    nil
  end

  private

  def current_dependency(attribute)
    attribute_factory_ivar = "@__#{attribute}_block__"
    instance_variable_get(attribute_factory_ivar)
  end

  def setup_dependencies(dependencies)
    Hash.new.tap do |current|
      dependencies.each do |attribute, dependency|
        current[attribute] = setup_dependency(attribute, dependency)
      end
    end
  end

  def setup_dependency(attribute, dependency)
    current_dependency(attribute).tap do |current_ivar|
      if dependency.kind_of? Proc
        send(attribute, &dependency)
      else
        send(attribute) { dependency }
      end
    end
  end

end

class Module
  include AttrDependency
end
