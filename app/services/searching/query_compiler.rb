# frozen_string_literal: true

module Searching
  # @see Entity.apply_query
  # @api private
  class QueryCompiler
    include Dry::Initializer[undefined: false].define -> do
      param :text, Searching::Types::String.optional

      option :dictionary, Searching::Types::String, default: proc { "english" }

      option :scope, Searching::Types::Interface(:all), default: proc { Entity.all }
    end

    # @return [ActiveRecord::Relation<::Entity>]
    def call
      return scope if text.blank?

      scope.search_by_query(text)
    end
  end
end
