# frozen_string_literal: true

module Contributors
  # @see Contributors::Lookup
  class Finder
    include Dry::Initializer[undefined: false].define -> do
      option :field, Contributors::Types::LookupField
      option :value, Contributors::Types::String
      option :order, Contributors::Types::LookupOrder, default: proc { "RECENT" }
    end

    include Dry::Monads[:result, :do]

    def call
      return Failure[:invalid, "must provide a non-blank value"] if value.blank?

      loader = yield build_loader

      Success loader.load value
    end

    private

    def build_loader
      column = yield derive_column_from_field

      order = yield derive_order_expression

      options = { column:, order: }

      loader = Support::Loaders::RecordLoader.for(::Contributor, **options)

      Success loader
    end

    def derive_column_from_field
      Success field
    end

    def derive_order_expression
      unless order == "OLDEST"
        Success(created_at: :desc)
      else
        Success(created_at: :asc)
      end
    end
  end
end
