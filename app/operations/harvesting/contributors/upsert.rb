# frozen_string_literal: true

module Harvesting
  module Contributors
    class Upsert
      include Dry::Monads[:do, :result]
      include Dry::Effects.Resolve(:harvest_source)
      include MonadicPersistence
      include WDPAPI::Deps[
        connect_or_create: "harvesting.contributors.connect_or_create",
      ]

      prepend TransactionalCall

      def call(kind, attributes, properties)
        harvest_contributor = yield upsert_by_kind kind, attributes, properties

        yield connect_or_create.call harvest_contributor

        Success harvest_contributor
      end

      private

      def upsert_by_kind(kind, attributes, properties)
        props = yield props_for_kind kind, properties

        identifier = attributes.delete(:identifier) || props.digest

        contributor = harvest_source.harvest_contributors.by_identifier(identifier).first_or_initialize

        contributor.kind = kind

        contributor.assign_attributes attributes

        contributor.properties = props

        monadic_save contributor
      end

      def props_for_kind(kind, properties)
        case kind
        when :person
          Success ::Contributors::Properties.new person: properties
        when :organization
          Success ::Contributors::Properties.new organization: properties
        else
          # :nocov:
          Failure[:invalid_kind, "cannot upsert contributor of kind: #{kind.inspect}"]
          # :nocov:
        end
      end
    end
  end
end
