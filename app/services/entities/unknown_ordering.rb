# frozen_string_literal: true

module Entities
  class UnknownOrdering < Entities::Error
    # @return [String]
    attr_reader :ordering_identifier

    # @return [String]
    attr_reader :available_orderings

    message_keys! :ordering_identifier

    message_format! <<~MSG
    [%<declaration>s] does not have ordering: %<ordering_identifier>s
    MSG

    did_you_mean_with! :ordering_identifier, :available_orderings

    # @param [#to_s] ordering_identifier
    def initialize(ordering_identifier:, entity:, **options)
      @ordering_identifier = ordering_identifier.to_s

      @available_orderings = Array(entity.schema_version.ordering_identifiers)

      super
    end
  end
end
