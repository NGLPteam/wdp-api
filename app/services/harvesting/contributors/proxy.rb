# frozen_string_literal: true

module Harvesting
  module Contributors
    # A tangential model that represents a {HarvestContributor} before storing
    # in the database. It's contained within a {Harvesting::Contributions::Proxy}.
    #
    # @see Harvesting::Contributions::Proxy
    # @see Harvesting::Contributors::Upsert
    # @see Harvesting::Contributors::Upserter
    class Proxy < Support::WritableStruct
      include ActiveModel::Validations
      include Dry::Core::Constants

      ATTRIBUTES = %i[
        identifier
        email
        prefix
        suffix
        bio
        orcid
        url
      ].freeze

      TRACKED = Harvesting::Types::Coercible::Array.of(Harvesting::Types::Coercible::String).default(EMPTY_ARRAY)

      attribute :kind, ::Contributors::Types::Kind

      attribute? :identifier, Harvesting::Types::String.optional
      attribute? :email, Harvesting::Types::String.optional
      attribute? :prefix, Harvesting::Types::String.optional
      attribute? :suffix, Harvesting::Types::String.optional
      attribute? :bio, Harvesting::Types::String.optional
      attribute? :orcid, Harvesting::Types::String.optional
      attribute? :properties, Harvesting::Types.Instance(::Contributors::Properties).optional
      attribute? :url, Harvesting::Types::String.optional

      attribute? :tracked_attributes, TRACKED
      attribute? :tracked_properties, TRACKED

      validates :identifier, :properties, presence: true

      validate :check_properties!

      def organization?
        kind == :organization
      end

      def person?
        kind == :person
      end

      # @return [::Contributors::OrganizationProperties, ::Contributors::PersonProperties]
      def specific_properties
        properties.__send__(kind)
      end

      # @param [HarvestSource] harvest_source
      # @return [HarvestContributor]
      def find_and_assign_for(harvest_source)
        harvest_source.harvest_contributors.where(identifier:).first_or_initialize.tap do |hc|
          assign_to! hc
        end
      end

      private

      # @param [HarvestContributor] harvest_contributor
      # @return [void]
      def assign_to!(harvest_contributor)
        harvest_contributor.assign_attributes(
          kind:,
          email:,
          prefix:,
          suffix:,
          bio:,
          orcid:,
          properties:,
          tracked_attributes:,
          tracked_properties:,
          url:
        )
      end

      # @return [void]
      def check_properties!
        return if properties.blank? || (specific_properties.blank? || specific_properties.valid?)

        specific_properties.errors.full_messages.each do |message|
          errors.add :base, message
        end
      end
    end
  end
end
