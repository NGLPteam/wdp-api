# frozen_string_literal: true

module Schemas
  module Static
    module Definitions
      class Version < Schemas::Static::Version
        def kind
          self[:kind]
        end

        def identifier
          self[:identifier]
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
            h[:kind] = kind
            h[:identifier] = identifier
            h[:name] = self[:name]
            h[:namespace] = namespace
          end
        end
      end
    end
  end
end
