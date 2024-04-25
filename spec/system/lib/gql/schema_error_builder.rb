# frozen_string_literal: true

module Testing
  module GQL
    class SchemaErrorBuilder
      include BuildableObject
      include Dry::Initializer[undefined: false].define -> do
        param :path, Dry::Types["coercible.string"]
      end

      before_build :set_path!

      def included_in(*items)
        set_message! I18n.t("dry_validation.errors.included_in?.arg.default", list:)

        return self
      end

      def exact(message)
        set_message! message
      end

      def message(key, **options)
        case key
        when Symbol, /\A\S+\z/
          set_message! I18n.t(key, **options, scope: %i[dry_validation errors])
        when Regexp, String
          exact key
        end
      end

      alias msg message

      private

      def set_path!
        prop :path, path
      end

      def set_message!(value)
        prop :message, value

        return self
      end

      class << self
        def build(path, key = nil, **options)
          new(path).build do |eb|
            eb.message key, **options if key.present?

            yield eb if block_given?
          end
        end
      end
    end
  end
end
