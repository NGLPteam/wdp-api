# frozen_string_literal: true

module EsploroSchema
  module Common
    # The base class for elements that serve as awkward wrappers around
    # data we actually want. It makes enumerating over them harder. This
    # class is used to simplify the enumeration and extraction of that
    # data.
    #
    # @abstract
    class AbstractWrapper < EsploroSchema::Common::AbstractMapper
      Subclass = EsploroSchema::Types::Class.constrained(lt: self)

      defines :wrapped_attribute_name, type: EsploroSchema::Types::WrappedAttributeName

      wrapped_attribute_name :_attribute_name_required

      # @return [Symbol]
      def wrapped_attribute_name
        self.class.wrapped_attribute_name
      end

      # @return [Array]
      def wrapped_values
        Array(__send__(wrapped_attribute_name))
      end

      class << self
        # @return [void]
        def wraps!(name)
          wrapped_attribute_name name
        end
      end
    end
  end
end
