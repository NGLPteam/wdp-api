# frozen_string_literal: true

module Searching
  # @see Entity.apply_prefix
  # @api private
  class PrefixCompiler
    include Dry::Initializer[undefined: false].define -> do
      param :input, Searching::Types::String.optional

      option :dictionary, Searching::Types::String, default: proc { "english" }

      option :scope, Searching::Types::Interface(:all), default: proc { Entity.all }
    end

    include MeruAPI::Deps[
      prefix_sanitize: "searching.prefix_sanitize",
    ]

    # @return [ActiveRecord::Relation<::Entity>]
    def call
      # needle = prefix_sanitize.(input)

      return scope if input.blank?

      scope.where(id: ::Entity.search_by_prefix(input).select(::Entity.arel_table[:id]))
    end
  end
end
