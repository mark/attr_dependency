require 'spec_helper'

include AttrDependency

describe NamespaceSplitter do

  module OuterClass
    module MiddleClass
      module InnerClass; end
    end
  end

  it "should be able to get the last piece" do
    NamespaceSplitter.leaf_name(OuterClass::MiddleClass::InnerClass).must_equal "InnerClass"
  end

  it "should describe the trunk" do
    NamespaceSplitter.trunk(OuterClass::MiddleClass::InnerClass).must_equal [["OuterClass", OuterClass], ["MiddleClass", OuterClass::MiddleClass]]
  end

end
