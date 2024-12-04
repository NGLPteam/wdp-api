# frozen_string_literal: true

module Entities
  class UnknownAncestor < Entities::Error
    # @return [String]
    attr_reader :ancestor_name

    # @return [String]
    attr_reader :available_ancestors

    message_keys! :ancestor_name

    message_format! <<~MSG
    [%<declaration>s] does not have ancestor: %<ancestor_name>s
    MSG

    did_you_mean_with! :ancestor_name, :available_ancestors

    # @param [#to_s] ancestor_name
    def initialize(ancestor_name:, entity:, **options)
      @ancestor_name = ancestor_name.to_s

      @available_ancestors = entity.schema_version.ancestor_names

      super
    end
  end
end
