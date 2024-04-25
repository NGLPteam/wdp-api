# frozen_string_literal: true

require_relative "../types"

module Testing
  module GQL
    class AttributeErrorBuilder
      include Dry::Initializer[undefined: false].define -> do
        param :path, ::Testing::Types::CamelizedErrorPath
      end

      ERROR_SCOPES = %w[
        dry_validation.errors.rules
        dry_validation.errors
      ].freeze

      def included_in(*items)
        list = items.flatten.join(", ")

        messages << I18n.t("dry_validation.errors.included_in?.arg.default", list:)
      end

      def exact(message)
        messages << message

        return self
      end

      def message(key, **options)
        case key
        when Symbol, /\A\S+\z/
          path, *default = ERROR_SCOPES.map { :"#{_1}.#{key}" }

          messages << I18n.t(path, **options, scope: nil, default:, raise: true)
        when Regexp
          messages << key
        end

        return self
      end

      alias msg message

      def to_error
        {
          path:,
          messages:,
        }
      end

      private

      def messages
        @messages ||= []
      end

      class << self
        def build(path, key = nil, **options)
          AttributeErrorBuilder.new(path).tap do |eb|
            eb.message key, **options if key.present?

            yield eb if block_given?
          end.to_error
        end
      end
    end
  end
end
