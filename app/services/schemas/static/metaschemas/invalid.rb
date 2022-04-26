# frozen_string_literal: true

module Schemas
  module Static
    module Metaschemas
      class Invalid < Dry::Struct
        include Dry::Monads[:result]
        include Dry::Core::Equalizer.new(:metaschema, :target)

        transform_keys(&:to_sym)

        attribute :metaschema do
          attribute :name, Dry::Types["string"]
          attribute :version, Dry::Types["coercible.string"]

          def inspect
            "#{name}(#{version})"
          end
        end

        attribute :target do
          attribute? :namespace, Dry::Types["string"].fallback("$unknown_ns$")
          attribute? :identifier, Dry::Types["string"].fallback("$unknown_id$")
          attribute? :version, Dry::Types["string"].fallback("$unknown_version$")
          attribute? :kind, Dry::Types["string"].fallback("$unknown$")

          def inspect
            %[#{kind}("#{namespace}:#{identifier}:#{version}")]
          end
        end

        attribute :schema, Dry::Types["hash"].optional

        attribute :errors, Dry::Types["array"].of(Dry::Types["hash"])

        # @return [Dry::Monads::Failure(:invalid_schema, Schemas::Static::Metaschemas::Invalid)]
        def to_monad
          Failure[:invalid_schema, self]
        end
      end
    end
  end
end
