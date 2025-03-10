# frozen_string_literal: true

module Harvesting
  module Contributions
    # A proxy object suitable for use with various harvesting subsystems
    # that represents both a {HarvestContribution} and a {HarvestContributor}.
    #
    # @see Harvesting::Contributors::Proxy
    # @see Harvesting::Contributions::Upsert
    # @see Harvesting::Contributions::Upserter
    # @see Harvesting::Contributors::Upsert
    class Proxy < ::Support::WritableStruct
      include ActiveModel::Validations
      include Support::Typing

      attribute? :contributor, Harvesting::Types.Instance(Harvesting::Contributors::Proxy).optional
      attribute? :role_name, Harvesting::Types::String.optional
      attribute? :role, Harvesting::Types.Instance(::ControlledVocabularyItem).optional.default(nil)
      attribute? :metadata, Harvesting::Types::EmptyDefaultHash
      attribute? :inner_position, Harvesting::Types::Coercible::Integer.optional.default(nil)
      attribute? :outer_position, Harvesting::Types::Coercible::Integer.optional.default(nil)

      validates :contributor, presence: true

      validate :check_contributor!

      def has_contributor?
        contributor.present?
      end

      private

      # @return [void]
      def check_contributor!
        return if !has_contributor? || contributor.valid?

        contributor.errors.full_messages.each do |message|
          errors.add :contributor, message
        end
      end
    end
  end
end
