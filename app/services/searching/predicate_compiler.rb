# frozen_string_literal: true

module Searching
  # @see Entity.apply_search_predicates
  # @api private
  class PredicateCompiler
    include Dry::Effects::Handler.State(:joins)
    include Dry::Effects::Handler.Resolve
    include Dry::Initializer[undefined: false].define -> do
      param :predicates, Searching::Operator::List.optional, default: proc { [] }

      option :encode_join, Searching::Types::JoinEncoder, default: proc { WDPAPI::Container["searching.compilation.encode_join_name"] }

      option :scope, Searching::Types::Interface(:all), default: proc { Entity.all }
    end

    # @return [ActiveRecord::Relation<::Entity>, nil]
    def call
      return nil if predicates.blank?

      compiled = compile

      return nil if compiled[:conditions].blank?

      query = scope.select(:id)

      query.where! compiled[:conditions]

      query.joins!(*compiled[:joins].values) if compiled[:joins].any?

      return query.apply_order_to_exclude_duplicate_links
    end

    private

    def compile
      wrap_predicate_compilation do |compiled|
        compiled[:conditions] = predicates.map(&:call).compact.reduce(nil) do |expr, pred|
          expr.present? ? expr.and(pred) : pred
        end
      end
    end

    def wrap_predicate_compilation
      joins = Concurrent::Map.new

      expression = {}

      joins, _ = with_joins(joins) do
        provide encode_join: encode_join do
          yield expression
        end
      end

      expression[:joins] = joins.each_pair.to_h

      return expression
    end
  end
end
