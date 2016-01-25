require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

class ParameterCounter <Parser::AST::Processor
  attr_reader :total
  
  def initialize
    @total = 0
  end
	
  def on_argument(node)
  	super(node)
    @total += 1
  end
end

module Measurement
  class MethodMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      {
        lines_of_code: count_lines_of_code(method),
        number_of_parameters: count_parameters(method)
      }
    end

    def count_lines_of_code(method)
      method.source.lines.count
    end

    def count_parameters(method)
      counter = ParameterCounter.new
      counter.process(method.ast)
      counter.total
    end
  end
end
