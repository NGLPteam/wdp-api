# frozen_string_literal: true

require_relative "concerns/with_migration_options"
require_relative "concerns/with_name"
require_relative "concerns/with_default_options"
require_relative "concerns/with_description"
require_relative "support/normalized_gql"

module DSL
  class Attribute
    attr_reader :model

    include Cleanroom
    include WithMigrationOptions
    include WithName
    include WithDefaultOptions
    include WithDescription

    delegate :schema, to: :model
    delegate :type_aliases, :type_alias_registered?, :find_type_alias, to: :schema

    default_options null: false, expose_in_gql: true, order_on: false, unique: false

    DEFAULT_NAME_OPTIONS = {
      position: { null: false, default: 0, order_on: true }
    }.freeze

    DEFAULT_TYPE_OPTIONS = {
      boolean: { null: false, default: false },
    }.freeze

    def initialize(model, name, type = nil, **options, &)
      @model = model
      @name = name
      @type = type.presence || name
      @requested_options = options
      @options = with_default_options(options)

      instance_eval(&) if block_given?
    end

    def name
      @name.to_s
    end

    def requested_options
      @requested_options || {}
    end

    def options
      calculated_options
    end

    def requested_type
      @type
    end

    def type
      calculated_type || requested_type
    end

    def calculated_type
      type_alias_registered?(requested_type) ? find_type_alias(requested_type).type : requested_type
    end

    def calculated_type_options
      type_alias_registered?(requested_type) ? find_type_alias(requested_type).options.dup : {}
    end

    def default_type_options
      DEFAULT_TYPE_OPTIONS.key?(type) ? DEFAULT_TYPE_OPTIONS[type].dup : {}
    end

    def default_name_options
      DEFAULT_NAME_OPTIONS.key?(name.to_sym) ? DEFAULT_NAME_OPTIONS[name.to_sym].dup : {}
    end

    def calculated_options
      @calculated_options ||= @options
        .merge(default_type_options)
        .merge(default_name_options)
        .merge(requested_options)
        .merge(calculated_type_options)
    end

    def gql_type
      case type
      when :string, :text
        "String"
      when :integer, :bigint
        "Integer"
      when :float, :decimal
        "Float"
      when :datetime, :time, :timestamp
        "GraphQL::Types::ISO8601DateTime"
      when :date
        "GraphQL::Types::ISO8601Date"
      when :boolean
        "Boolean"
      else
        "String"
      end
    end

    def gql_field
      Support::NormalizedGQL::Field.new(name: name.to_sym, type: gql_type, null: options[:null])
    end

    def expose_in_gql?
      return false if type == :jsonb

      options[:expose_in_gql]
    end

    # rubocop:disable Metrics/PerceivedComplexity
    def set_factory_default
      return options[:faker] if options.key?(:faker)

      return '3.33' if type == :decimal
      return "Faker::Time.backward.iso8601" if [:datetime, :timestamp, :time].include? type
      return 'Date.today.to_fs(:db)' if type == :date

      return "1" if requested_type == :integer
      return "1.5" if requested_type == :float
      return '9.99' if requested_type == :money
      return 'true' if requested_type == :default_true
      return 'false' if requested_type == :default_false
      return '1.0' if requested_type == :p100
      return '0.0' if requested_type == :p0

      '""'
    end
    # rubocop:enable Metrics/PerceivedComplexity

    def factory_default
      @factory_default ||= set_factory_default
    end

    def order_on?
      @order_on ||= options[:order_on] == true
    end

    def unique?
      options[:unique] == true
    end

    def order_scopes
      [].tap do |os|
        os.concat(options[:order_scopes]) if options[:order_scopes].is_a?(Array)
      end.tap do |os|
        os.push(:tenant_id) if @model.tenant_model?
      end
    end
  end
end
