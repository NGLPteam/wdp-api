# frozen_string_literal: true

module Testing
  module GQL
    class GlobalErrorBuilder
      include BuildableObject
      include Dry::Initializer[undefined: false].define -> do
        param :input, Testing::Types::Any

        option :message_args, Testing::Types::Hash, default: proc { {} }

        option :type, Testing::Types::Coercible::String, default: proc { "$server" }
      end

      ERROR_SCOPES = %w[
        dry_validation.errors.rules
        dry_validation.errors
      ].freeze

      before_build :set_type!
      before_build :set_input!

      def message(key, **args)
        prop :message, parse_message(key, **args)
      end

      alias msg message

      private

      def parse_message(key, **options)
        case key
        when Symbol, /\A\S+\z/
          path, *default = ERROR_SCOPES.map { :"#{_1}.#{key}" }

          I18n.t(path, **options, scope: nil, default:, raise: true)
        when Regexp
          key
        end
      end

      def set_input!
        msg input, **message_args if input.present?
      end

      def set_type!
        prop :type, type
      end
    end
  end
end
