# frozen_string_literal: true

module Filtering
  # @api private
  class ArgumentBuilder
    include Dry::Initializer[undefined: false].define -> do
      param :type, Support::DryGQL::Types::Type

      option :required, Support::DryGQL::Types::Bool.default(false), optional: true, as: :provided_required
    end

    def call
      @current_type = type

      required! if provided_required

      yield self if block_given?

      return @current_type
    end

    def default(value, replace_null: false)
      augment_type do |t|
        t.meta(
          gql_default_value: value,
          gql_replace_null: replace_null,
        ) unless value.nil?
      end
    end

    def description(text)
      augment_type do |t|
        t.gql_description text
      end
    end

    def required!
      augment_type do |t|
        t.gql_required true
      end
    end

    private

    def augment_type
      new_type = yield @current_type

      @current_type = Support::DryGQL::Types::Type[new_type] if new_type.present?

      return
    end
  end
end
