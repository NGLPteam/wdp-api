# frozen_string_literal: true

module Schemas
  module Static
    module Definitions
      class Version < Schemas::Static::Version
        def consumer
          self[:consumer]
        end

        def identifier
          self[:id]
        end

        def number
          self[:version]
        end

        # @return [(String, String)]
        def to_definition_tuple
          [namespace, identifier]
        end

        def to_definition_attributes
          {}.tap do |h|
            h[:kind] = consumer
            h[:identifier] = identifier
            h[:name] = self[:name]
            h[:namespace] = namespace
          end
        end
      end
    end
  end
end
