# frozen_string_literal: true

module Templates
  module Definitions
    class EncodedDefault < Shale::Type::Value
      class << self
        # @param [Object] value
        # @return [Object]
        def of_xml(...)
          Oj.safe_load(super)
        end

        def as_xml_value(value)
          Oj.dump(value)
        end
      end
    end
  end
end
