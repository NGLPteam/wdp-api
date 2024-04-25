# frozen_string_literal: true

module Testing
  module GQL
    class MutationShaper < NamedObjectShaper
      include Predications

      option :schema, Dry::Types["bool"], default: proc { false }
      option :no_errors, Dry::Types["bool"], default: proc { true }
      option :no_global_errors, Dry::Types["bool"], default: proc { true }
      option :no_schema_errors, Dry::Types["bool"], default: proc { true }

      before_build :check_errors!

      def attribute_errors(...)
        body[:attribute_errors] = AttributeErrorsBuilder.build(...)

        return self
      end

      alias errors attribute_errors

      def global_errors(...)
        body[:global_errors] = GlobalErrorsBuilder.build(...)

        return self
      end

      def schema_errors(...)
        body[:schema_errors] = SchemaErrorsBuilder.build(...)

        return self
      end

      private

      # @return [void]
      def check_errors!
        body[:attribute_errors] = be_blank if no_errors
        body[:global_errors] = be_blank if no_global_errors
        body[:schema_errors] = be_blank if schema && no_schema_errors
      end
    end
  end
end
