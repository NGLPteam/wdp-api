# frozen_string_literal: true

module Harvesting
  module Metadata
    module OAIDC
      # @abstract
      class AbstractOAIDCDrop < Harvesting::Metadata::Drops::DataDrop
        private

        # @return [::Metadata::OAIDC::Root]
        attr_reader :root

        # @param [Lutaml::Model::Serializable] data
        def set_up!(data, **kwargs)
          super

          @root = metadata_context.root
        end
      end
    end
  end
end
