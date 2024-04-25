# frozen_string_literal: true

require_relative "concerns/with_migration_options"
require_relative "concerns/with_default_options"
require_relative "concerns/with_name"
require_relative "concerns/with_description"

module DSL
  class Reference
    include Cleanroom
    include WithMigrationOptions
    include WithName
    include WithDefaultOptions
    include WithDescription

    attr_reader :model, :source_model, :options, :name

    delegate :schema, to: :source_model

    default_options on_delete: :restrict, type: :uuid, expose_in_gql: true, optional: false

    def initialize(model, name, options, &)
      @source_model = model
      @name = name

      raw_options = options.is_a?(Symbol) || options.is_a?(String) ? { on_delete: options.to_sym } : options

      @options = with_default_options(raw_options)

      instance_eval(&) if block_given?
    end

    def target
      @name
    end

    def source
      source_model.singular_name
    end

    def target_model
      schema.find_model(target)
    end

    def to_tenant_model?
      target_model&.tenant_model?
    end

    def from_tenant_model?
      source_model&.tenant_model?
    end

    def tenant_foreign_key?
      from_tenant_model? && to_tenant_model?
    end

    def polymorphic?
      @options.key? :polymorphic
    end

    def polymorphic_targets
      @options[:polymorphic] || []
    end

    def on_delete
      @options[:on_delete]
    end

    def dependent
      return "destroy" if on_delete == :cascade
      return "nullify" if on_delete == :nullify
      return "restrict_with_error" if on_delete == :restrict

      "nil"
    end

    def concern_class_name
      @concern_class_name ||= options.fetch(:concern) { singular_name }.camelize
    end

    def concern_file_name
      @concern_file_name ||= concern_class_name.underscore
    end

    def gql_field
      Support::NormalizedGQL::Field.new(name: @name.to_sym, type: graphql_type_name, null: nullable?)
    end

    def gql_type_file_name
      graphql_type_name.underscore
    end

    def polymorphic_target_types
      polymorphic_target_models.map { |t| "Types::#{t.graphql_type_name}" }.join(", ")
    end

    def polymorphic_target_models
      polymorphic_targets.map { |t| schema.find_model(t) }
    end

    def graphql_type_name
      return "Any#{concern_class_name}Type" if polymorphic?

      target_model.graphql_type_name
    end

    def target_factory
      return name if polymorphic?

      target_model&.factory_name
    end

    def expose_in_gql?
      @options[:expose_in_gql]
    end

    def nullable?
      options[:optional] == true
    end
  end
end
