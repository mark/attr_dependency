require 'attr_dependency/attr_dependency'
require 'attr_dependency/dependency_manager'
require 'attr_dependency/dependency_setter'
require 'attr_dependency/namespace_splitter'
require 'attr_dependency/namespace_shadow'

class Module
  include AttrDependency
end
