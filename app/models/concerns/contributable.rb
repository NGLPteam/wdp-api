# frozen_string_literal: true

# A concern for records that may have any number of {Contribution contributions} from a {Contributor}.
#
# @see Collection
# @see Item
module Contributable
  extend ActiveSupport::Concern
  extend DefinesMonadicOperation

  included do
    extend Dry::Core::ClassAttributes

    defines :contributable_foreign_key, type: Contributions::Types::ContributableForeignKey
    defines :contributable_key, type: Contributions::Types::ContributableKey
    defines :contributions_klass_name, type: Contributions::Types::ContributionKlassName

    contributable_key :"#{model_name.singular}"
    contributable_foreign_key :"#{contributable_key}_id"
    contributions_klass_name "#{model_name}Contribution"

    delegate :contributions_klass, to: :class
  end

  # @see Contributions::Attach
  # @see Contributions::Attacher
  # @return [Dry::Monads::Success(Contribution)]
  monadic_operation! def attach_contribution(contributor, **options)
    call_operation("contributions.attach", contributor, self, **options)
  end

  # @!attribute [r] contributable_foreign_key
  # @return [Contributions::Types::ContributableForeignKey]
  def contributable_foreign_key
    self.class.contributable_foreign_key
  end

  # @!attribute [r] contributable_key
  # @return [Contributions::Types::ContributableKey]
  def contributable_key
    self.class.contributable_key
  end

  # @!attribute [r] contributions_klass_name
  # @return [Contributions::Types::ContributionKlassName]
  def contributions_klass_name
    self.class.contributions_klass_name
  end

  module ClassMethods
    # @return [Class<::Contribution>]
    def contributions_klass
      @contributions_klass ||= contributions_klass_name.constantize
    end
  end
end
