# frozen_string_literal: true

module Harvesting
  module Metadata
    module ValueExtraction
      module Accessors
        # Access a source by an XPath-style query.
        #
        # It expects something that implements Nokogiri's
        # `at_xpath(query, namespaces)` method signature.
        class XPath < Harvesting::Metadata::ValueExtraction::Accessor
          include Dry::Effects.Resolve(:namespaces)

          param :query, Harvesting::Types::String.constrained(rails_present: true)

          source_type Harvesting::Types::Interface(:at_xpath)

          # @param [#at_xpath] source
          # @return [Dry::Monads::Success(Nokogiri::XML::Element)]
          # @return [Dry::Monads::Failure(:empty_xpath, Hash)]
          def extract(source)
            ns = namespaces { {} }

            node = source.at_xpath query, **ns

            return extraction_error! :empty_xpath, source: source, query: query, namespaces: ns if node.blank?

            Success node
          end
        end
      end
    end
  end
end
