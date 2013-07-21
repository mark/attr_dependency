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

end

class Module
  include AttrDependency
end
