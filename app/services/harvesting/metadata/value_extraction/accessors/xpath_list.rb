# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module Accessors
        # Access a source by an XPath-style query and retrieve multiple nodes.
        #
        # It expects something that implements Nokogiri's
        # `at_xpath(query, namespaces)` method signature.
        class XPathList < Harvesting::Metadata::ValueExtraction::Accessor
          include Dry::Effects.Resolve(:namespaces)

          param :query, Harvesting::Types::String.constrained(rails_present: true)

          source_type Harvesting::Types::Interface(:at_xpath)

          # @param [#xpath] source
          # @return [Dry::Monads::Success(Nokogiri::XML::NodeSet)]
          # @return [Dry::Monads::Failure(:empty_xpath, Hash)]
          def extract(source)
            ns = namespaces { {} }

            nodes = source.xpath query, **ns

            Success nodes
          end
        end
      end
    end
  end
end
