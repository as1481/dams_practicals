require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/class_locator"

class MethodCounter <Parser::AST::Processor
  attr_reader :total
  
  def initialize
    @total = 0
  end
	
  def on_def(node)
  	super(node)
    @total += 1
  end
end

class ClassMethodCounter <Parser::AST::Processor
  attr_reader :total
  
  def initialize
    @total = 0
  end

  def on_defs(node)
  	super(node)
    @total += 1
  end
end

class AttributeCounter <Parser::AST::Processor
  attr_reader :total
  attr_reader :attributes
  
  def initialize
    @total = 0
    @attributes = []
  end
	
  def on_lvasgn(node)
  	super(node)
  	
  	if (!attributes.include? node.to_a[0])
	  @total += 1
	  @attributes.push(node.to_a[0])
	end
  end
end

module Measurement
  class ClassMeasurer < Measurer
    def locator
      Locator::ClassLocator.new
    end

    def measurements_for(clazz)
      {
        lines_of_code: count_lines_of_code(clazz),
        number_of_methods: count_methods(clazz),
        number_of_class_methods: count_class_methods(clazz),
        number_of_attributes: count_attributes(clazz)
      }
    end

    def count_lines_of_code(clazz)
      clazz.source.lines.count
    end

    def count_methods(clazz)
      counter = MethodCounter.new
      counter.process(clazz.ast)
      counter.total
    end

    def count_class_methods(clazz)
      counter = ClassMethodCounter.new
      counter.process(clazz.ast)
      counter.total
    end

    def count_attributes(clazz)
      counter = AttributeCounter.new
      counter.process(clazz.ast)
      counter.total
    end
  end
end
