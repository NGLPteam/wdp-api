# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      class NameDrop < ::Liquid::Drop
        # @param [Metadata::OAIDC::Naming::Name] name
        def initialize(name)
          @name = name
          @given = name.given
          @family = name.family

          @display_name = name.display_name

          @exists = @name.valid?
        end

        # @return [String]
        attr_reader :display_name

        alias to_s display_name

        # @return [Boolean]
        attr_reader :exists

        # @return [String]
        attr_reader :family

        # @return [String]
        attr_reader :given
      end
    end
  end
end
