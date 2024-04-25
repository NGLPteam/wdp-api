# frozen_string_literal: true

module Resolvers
  module Enhancements
    module FirstMatching
      extend ActiveSupport::Concern

      included do
        extension Resolvers::Enhancements::FirstMatching::Extension, resolver: self
      end

      # @api private
      class Extension < GraphQL::Schema::FieldExtension
        # @param [ActiveRecord::Relation, #first] value
        def after_resolve(value:, **)
          value.first
        end
      end
    end
  end
end
