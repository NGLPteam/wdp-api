# frozen_string_literal: true

module TestHelpers
  class OrderingMutator
    def mutate!(ordering, persist: true)
      yield self

      ordering.save! if persist

      return ordering
    end

    # @param [Ordering] ordering
    # @param [String] path
    def add_paths_to(ordering, *paths, direction: :asc, nulls: :last, clear_previous: false)
      paths.flatten!

      mutate_definition! ordering do |defn|
        order = clear_previous ? [] : Array(defn[:order])

        order += paths.map do |path|
          { path: path, direction: direction, nulls: nulls }
        end

        defn.merge(order: order)
      end
    end

    private

    # @param [Ordering] ordering
    # @return
    def mutate_definition!(ordering)
      current = ordering.definition.as_json.with_indifferent_access

      modified = yield current

      ordering.definition = modified

      return ordering
    end
  end

  module OrderingMutationExampleHelpers
    def mutate_ordering!(ordering)
      ordering_mutator.mutate! ordering do |om|
        yield om
      end
    end

    def ordering_mutator
      @ordering_mutator ||= OrderingMutator.new
    end

    def set_ordering_paths!(ordering, *paths, direction: :asc, nulls: :last)
      mutate_ordering! ordering do |om|
        om.add_paths_to ordering, *paths, direction: direction, nulls: nulls, clear_previous: true
      end
    end
  end
end

RSpec.configure do |config|
  config.include TestHelpers::OrderingMutationExampleHelpers, orderings: true
end
