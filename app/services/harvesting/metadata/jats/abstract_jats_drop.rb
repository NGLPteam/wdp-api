# frozen_string_literal: true

module Harvesting
  module Metadata
    module JATS
      # @abstract
      class AbstractJATSDrop < Harvesting::Metadata::Drops::DataDrop
        data_attr! :id, :string

        private

        # @return [Niso::Jats::Article]
        attr_reader :article

        # @param [Lutaml::Model::Serializable] data
        def set_up!(data, **kwargs)
          super

          @article = metadata_context.article
        end
      end
    end
  end
end
