# frozen_string_literal: true

module Templates
  module Validators
    class ModelValidator < Support::HookBased::Actor
      extend ActiveModel::Callbacks

      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
      include Dry::Core::Memoizable

      include Dry::Initializer[undefined: false].define -> do
        param :template, Templates::Types::TemplateRecord

        option :definition_klass, Templates::Types::Class.constrained(model_class: true), default: -> { template.definition_klass }

        option :instance_klass, Templates::Types::Class.constrained(model_class: true), default: -> { template.instance_klass }
      end

      delegate :defined_prop_names, to: :template

      before_validation :fetch_prop_names!

      validate :all_props_accounted_for!

      private

      def all_props_accounted_for!
        defined_prop_names.each do |prop_name|
          errors.add :base, "#{definition_klass} is missing config property: #{prop_name}" unless prop_name.in?(definition_klass.column_names)
        end
      end
    end
  end
end
