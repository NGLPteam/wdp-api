# frozen_string_literal: true

module Harvesting
  module Contributions
    # For very simple contribution / contributor pairs, we can use this to generate proxies
    #
    # @see Harvesting::Contributions::Proxy
    class SimpleParse
      include Dry::Monads[:do, :result]
      include MeruAPI::Deps[
        parse_name_to_properties: "contributors.parse_name_to_properties",
      ]

      # @return [Dry::Monads::Success(Harvesting::Contributions::Proxy)]
      def call(name, kind:, contributor_kind:, identifier: nil, attributes: {}, metadata: {})
        attributes[:identifier] ||= identifier if identifier.present?

        properties = yield parse_name_to_properties.(name, kind: contributor_kind)

        contributor = {
          kind: contributor_kind,
          attributes:,
          properties:,
        }

        contribution = {
          kind:,
          metadata:,
          contributor:,
        }

        proxy = Harvesting::Contributions::Proxy.new contribution

        Success proxy
      end
    end
  end
end
