# frozen_string_literal: true

module Contributors
  SharedSchema = Dry::Schema.JSON do
    optional(:email).maybe(:string)
    optional(:url).maybe(:string)
    optional(:bio).maybe(:string)

    optional(:links).array(:hash) do
      required(:title).filled(:string)
      required(:url).filled(:string)
    end
  end
end
