# frozen_string_literal: true

module AssignsPolymorphicForeignKey
  extend ActiveSupport::Concern

  # @param [#to_sym] association_name
  # @return [AssignsPolymorphicForeignKey::Definition, nil]
  def polymorphic_foreign_key_definition_for(association_name)
    self.class.polymorphic_foreign_keys[association_name]
  end

  # @param [ApplicationRecord] model
  # @param [AssignsPolymorphicForeignKey::Definition] definition
  # @return [Symbol]
  def polymorphic_foreign_key_for(model, definition)
    definition.foreign_key_for model
  end

  module ClassMethods
    def polymorphic_foreign_keys
      @polymorphic_foreign_keys ||= defined?(super) ? super.deep_dup : {}.with_indifferent_access
    end

    def assign_polymorphic_foreign_key!(name, *foreign_keys, **options)
      foreign_keys.flatten!

      definition = Definition.new(name, foreign_keys, **options)

      polymorphic_foreign_keys[definition.name] = definition

      mod = ValidationMethods.new definition

      include mod

      before_validation definition.validation_method_name
    end
  end

  # @api private
  class Definition
    extend Dry::Initializer

    param :name, AppTypes::Coercible::Symbol
    param :foreign_keys, AppTypes::Array.of(AppTypes::Coercible::Symbol)
    option :required_interface, AppTypes.Instance(Module), optional: true

    # @param [ApplicationRecord] model
    # @return [Symbol]
    def foreign_key_for(model)
      model.model_name.i18n_key
    end

    def foreign_key_assignments_for(model_key, model)
      foreign_keys.index_with do |key|
        model_key == key ? model : nil
      end
    end

    def validation_method_name
      @validation_method_name ||= :"sync_#{name}!"
    end
  end

  # @!scope private
  class ValidationMethods < Module
    delegate :validation_method_name, to: :@definition

    def initialize(definition)
      @definition = definition

      generate_methods!
    end

    private

    # @return [void]
    def generate_methods!
      defn = @definition

      define_method(validation_method_name) do
        model = public_send(defn.name)

        foreign_key = polymorphic_foreign_key_for(model, defn)&.to_sym

        if foreign_key.in?(defn.foreign_keys)
          assignments = defn.foreign_key_assignments_for(foreign_key, model)

          assign_attributes assignments
        else
          errors.add defn.name, "is not set with a valid model: #{model.model_name}"
        end
      end
    end
  end
end
