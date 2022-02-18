# frozen_string_literal: true

module Schemas
  class BaseContract < ApplicationContract
    include WDPAPI::Deps[
      matches_models: "models.matches"
    ]

    config.types = Schemas::Properties::Types::Registry

    register_macro :typed_schematic_reference do |macro:, index:|
      # Skip if we have already recorded an error for this path
      next if rule_error?

      # There is no point in checking nil values here
      next if value.blank?

      parent_key = index ? keys[0][0...-1] : nil

      models = macro.args

      matches_models.call(value, allowed: models) do |m|
        m.success do
          # Intentionally left blank
        end

        m.failure do
          tokens = {
            actual: value.class.name,
            models: models.map(&:model_name).join(", "),
          }

          i18n_key = :"schematic_references.#{index ? :collected : :scalar}.must_match"

          message = {
            text: i18n_key,
          }

          if index.present?
            message[:index] = index

            tokens[:index_ord] = index.ordinalize
            tokens[:ord] = (index + 1).ordinalize

            key(parent_key).failure(message, tokens)
          else
            key.failure(message, tokens)
          end
        end
      end
    end
  end
end
