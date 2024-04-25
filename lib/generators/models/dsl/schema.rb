# frozen_string_literal: true

require_relative "model"
require_relative "attribute"
require_relative "reference"
require_relative "state_machine"
require_relative "type_alias"
require_relative "mutation"
require_relative "concerns/with_feedback"

module DSL
  class Schema
    include Cleanroom
    include WithFeedback

    attr_accessor :models, :type_aliases

    def initialize
      @models = []
      @type_aliases = [
        DSL::TypeAlias.new(:p100, :decimal, precision: 4, scale: 3, null: false, default: 1.000),
        DSL::TypeAlias.new(:p0, :decimal, precision: 4, scale: 3, null: false, default: 0.000),
        DSL::TypeAlias.new(:money, :decimal, precision: 21, scale: 3, null: false, default: 0.000),
        DSL::TypeAlias.new(:default_true, :boolean, null: false, default: true),
        DSL::TypeAlias.new(:default_false, :boolean, null: false, default: false),
        DSL::TypeAlias.new(:phone, :text, faker: "Faker::PhoneNumber.unique.phone_number", null: true),
        DSL::TypeAlias.new(:cell, :text, faker: "Faker::PhoneNumber.unique.cell_phone", null: true),
      ]
    end

    def model(name, options = {}, &)
      register_model DSL::Model.new(self, name, **options, &)
      validate_schema
    end
    expose :model

    def type_alias(name, type, options = {})
      register_type_alias DSL::TypeAlias.new(name, type, options)
    end
    expose :type_alias

    def all_references
      models.reduce([]) { |refs, m| refs.concat(m.references) }
    end

    def register_model(model)
      models.push model unless model_registered?(model.key)
    end

    def register_type_alias(type_alias)
      type_aliases.push type_alias unless type_alias_registered?(type_alias.key)
    end

    def any_state_machine?
      models.any? { |m| m.state_machine? }
    end

    def any_tenant_models?
      models.any? { |m| m.tenant_model? }
    end

    def model_registered?(key)
      find_model(key).present?
    end

    def find_model(key)
      models.find { |m| m.key == key.to_sym }
    end

    def polymorphic_gql_references
      [].tap do |refs|
        models.each do |model|
          refs.concat model.polymorphic_gql_references
        end
      end
    end

    def type_alias_registered?(key)
      find_type_alias(key).present?
    end

    def find_type_alias(key)
      type_aliases.find { |a| a.key == key.to_sym }
    end

    def factory_alias(factory_name)
      return nil unless factory_aliases.key? factory_name.to_sym

      factory_aliases[factory_name.to_sym]
    end

    def factory_aliases
      @factory_aliases ||= {}.tap do |aliases|
        polymorphic_gql_references.each do |ref|
          next if ref.polymorphic_targets.empty?

          aliases[ref.polymorphic_targets.first] = ref.name
        end
      end
    end

    private

    def validate_schema
      warnings = []

      missing_targets = all_references.filter { |r| r.target_model.blank? }
      unless missing_targets.empty?
        missing_targets.each do |mt|
          msg_1 = "The target model for reference :#{mt.key} on model :#{mt.source_model.key} is not defined in this schema."
          msg_2 = "The has_many side of this reference will not be reflected in generated files."
          warnings.push msg_1
          warnings.push msg_2
        end
      end

      if warnings.any?
        Rails.logger.debug ""
        say "Schema warnings"
        warnings.each { |w| say(w, subitem: true) }
        Rails.logger.debug ""
      end
    end
  end
end
