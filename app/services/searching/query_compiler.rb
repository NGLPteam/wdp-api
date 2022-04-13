# frozen_string_literal: true

module Searching
  # @see Entity.apply_search_predicates
  # @api private
  class QueryCompiler
    include Dry::Initializer[undefined: false].define -> do
      param :text, Searching::Types::String.optional

      option :dictionary, Searching::Types::String, default: proc { "english" }

      option :scope, Searching::Types::Interface(:all), default: proc { Entity.all }
    end

    # @return [ActiveRecord::Relation<::Entity>, nil]
    def call
      base_scope = scope.apply_order_to_exclude_duplicate_links

      return base_scope if text.blank?

      base_scope.by_composed_text(text, dictionary: dictionary)
    end
  end
end
