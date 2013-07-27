require 'spec_helper'
require 'securerandom'

describe AttrDependency do

  it "should be a method on classes" do
    Class.new.must_respond_to :attr_dependency
  end

  describe "basic dependency behavior" do

    class MyClass
      attr_dependency Array
    end

    it "should define the dependency injector" do
      MyClass.must_respond_to :dependencies
    end

    describe "performing dependency injection" do

      subject { MyClass.new }

      it "should default to the real dependency" do
        obj = MyClass.new
        obj.instance_eval("Array").must_equal Array
      end

      it "should now return String" do
        MyClass.dependencies[Array] = String
        subject.instance_eval("Array").must_equal String
      end

      it "should be reversable" do
        MyClass.dependencies[Array] = String
        MyClass.dependencies[Array] = Array
        subject.instance_eval("Array").must_equal Array
      end

      it "should still allow you to access the original" do
        MyClass.dependencies[Array] = String
        subject.instance_eval("Array").must_equal String
        subject.instance_eval("::Array").must_equal Array
      end

    end

    after { MyClass.dependencies[Array] }

  end

  describe "with namespaced classes" do

    module FooClass
      class BarClass; end
    end

    class YourClass
      attr_dependency FooClass::BarClass
    end

    subject { YourClass.new }

    it "should be injectable" do
      YourClass.dependencies[FooClass::BarClass] = String
      subject.instance_eval("FooClass::BarClass").must_equal String
    end

    it "should be reversable" do
      YourClass.dependencies[FooClass::BarClass] = String
      YourClass.dependencies[FooClass::BarClass] = FooClass::BarClass
      subject.instance_eval("FooClass::BarClass").must_equal FooClass::BarClass
    end

    it "should still allow you to access the original" do
      YourClass.dependencies[FooClass::BarClass] = String
      subject.instance_eval("::FooClass::BarClass").must_equal FooClass::BarClass
    end

  end
    
  describe "with very namespaced classes" do

    module FooClass
      class BarClass
        class BazClass; end
      end
    end

    class TheirClass
      attr_dependency FooClass::BarClass::BazClass
    end

    subject { TheirClass.new }

    it "should be injectable" do
      TheirClass.dependencies[FooClass::BarClass::BazClass] = String
      subject.instance_eval("FooClass::BarClass::BazClass").must_equal String
    end

    it "should be reversable" do
      TheirClass.dependencies[FooClass::BarClass::BazClass] = String
      TheirClass.dependencies[FooClass::BarClass::BazClass] = FooClass::BarClass::BazClass
      subject.instance_eval("FooClass::BarClass::BazClass").must_equal FooClass::BarClass::BazClass
    end

    it "should still allow you to access the original" do
      TheirClass.dependencies[FooClass::BarClass::BazClass] = String
      subject.instance_eval("::FooClass::BarClass::BazClass").must_equal FooClass::BarClass::BazClass
    end

  end

end
