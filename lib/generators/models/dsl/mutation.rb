# frozen_string_literal: true

require_relative "concerns/with_name"

module DSL
  class Mutation
    attr_reader :model, :verb

    delegate :schema, to: :model

    def initialize(model, verb, options = {})
      @model = model
      @verb = verb.to_sym
      @options = options
    end

    def generator_args(forced: false)
      [].tap do |args|
        args << mutation_name
        args << "--force" if forced
        args << "--fields=#{model.mutation_fields.to_json}"
        args << "--required=#{required_for_verb.to_json}"
        args << "--schema=tenant" if model.tenant_model?
      end
    end

    private

    def required_for_verb
      return [] unless create? || update?

      model.gql_references.map do |reference|
        { field: ":#{reference.name}", macro: :value, arg: ":#{reference.name}" }
      end
    end

    def update?
      verb == :update
    end

    def create?
      verb == :create
    end

    def mutation_suffix
      verb.to_s.camelize(:upper)
    end

    def mutation_name
      "#{model.class_name}#{mutation_suffix}"
    end
  end
end
