# frozen_string_literal: true

require_relative "concerns/with_name"
require_relative "concerns/with_description"
require_relative "concerns/with_default_options"

module DSL
  class Model
    include Cleanroom
    include WithName
    include WithDescription
    include WithDefaultOptions

    attr_reader :attributes, :state_machine, :references, :schema, :verbs

    default_options tenant: false, gql_type: true, slug: :ephemeral, gql_interface: false

    def initialize(schema, name, **options, &)
      @schema = schema
      @mutations = []
      @attributes = []
      @state_machine = nil
      @references = []
      @name = name
      @options = with_default_options(options)

      instance_eval(&) if block_given?
    end

    def slug_type
      @options[:slug]
    end

    expose def mutations(*verbs, **options)
      adjusted_verbs = verbs.empty? ? [:create, :update, :destroy] : verbs
      adjusted_verbs.each { |verb| @mutations.push(Mutation.new(self, verb, options)) }
    end

    expose def mutation(model, **options); end

    def defined_mutations
      @mutations
    end

    def mutation_fields
      [].tap do |fields|
        attributes.each do |a|
          fields.push({
            name: a.gql_field.name,
            type: a.gql_field.type,
            description: a.description,
            default: a.factory_default,
            required: false
          })
        end
        references.each do |r|
          fields.push({
            name: "#{r.key}_id",
            type: "ID",
            description: r.description,
            loads: r.gql_field.type,
            default: "FactoryBot.create(:#{r.target_factory}).to_encoded_id",
            required: true
          })
        end
      end
    end

    def mutation_input
      attributes_with_defaults = attributes.filter { |a| a.factory_default.present? }
      {}.tap do |input|
        attributes_with_defaults.each do |a|
          input[a.key] = a.factory_default
        end
      end
    end

    expose def states(*states)
      @state_machine = StateMachine.new(self, states)
    end

    expose def attribute(name, type = nil, **options, &)
      @attributes.push Attribute.new(self, name, type, **options, &)
    end

    alias a attribute

    expose :a

    expose def reference(name, options = {}, &)
      @references.push Reference.new(self, name, options, &)
    end

    alias r reference

    expose :r

    def has_many_references
      @schema.all_references.filter { |ref| ref.target_model == self }
    end

    def polymorphic_has_many_references
      @schema.all_references.filter { |ref| ref.polymorphic? && ref.polymorphic_targets.include?(key) }
    end

    def has_many_through_references
      has_many_references.map { |back_ref| back_ref.source_model }.reduce([]) do |refs, model|
        refs.concat model.references.filter { |out_ref| out_ref.target_model != self }
      end
    end

    def tenant_model_references
      references.filter { |r| r.tenant_foreign_key? }
    end

    def orderable?
      order_on_attribute.present?
    end

    def order_on_attribute
      attributes.find { |a| a.order_on? }
    end

    def order_scopes
      order_on_attribute&.order_scopes || []
    end

    def state_machine?
      state_machine.present?
    end

    def tenant_model?
      @options[:tenant] == true
    end

    alias tenant? tenant_model?

    def file_name
      @file_name ||= class_name.underscore
    end

    def class_name
      @class_name ||= singular_name.camelize
    end

    def module_name
      @module_name ||= plural_name.camelize
    end

    def factory_name
      @factory_name ||= class_name.underscore
    end

    def table_name
      @table_name ||= pluralize_table_names? ? plural_name : singular_name
    end

    def migration_class_name
      @migration_class_name ||= "Create#{class_name.pluralize}"
    end

    def references?
      references.blank?
    end

    def attribute?(key); end

    def attributes?
      attributes.blank?
    end

    def graphql_file_name
      graphql_type_name.underscore
    end

    def graphql_type_name
      "#{class_name}Type"
    end

    def gql_type?
      @options[:gql_type]
    end

    def gql_interface?
      @options[:gql_interface]
    end

    def polymorphic_gql_references?
      polymorphic_gql_references.any?
    end

    def polymorphic_gql_references
      @polymorphic_gql_references ||= gql_references.filter { |r| r.polymorphic? }
    end

    def gql_references
      @gql_references ||= references.filter { |a| a.expose_in_gql? }
    end

    def gql_references?
      gql_references.any?
    end

    def gql_fields
      @gql_fields ||= attributes.filter { |a| a.expose_in_gql? }
    end

    def gql_fields?
      gql_fields.any?
    end

    def unique_attributes
      attributes.filter { |a| a.unique? }
    end

    def factory_alias?
      factory_alias.present?
    end

    def factory_alias
      schema.factory_alias(factory_name)
    end

    private

    def pluralize_table_names?
      !defined?(ActiveRecord::Base) || ActiveRecord::Base.pluralize_table_names
    end
  end
end
