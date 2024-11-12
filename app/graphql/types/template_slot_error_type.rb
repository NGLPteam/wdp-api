# frozen_string_literal: true

module Types
  # @see Templates::Slots::Error
  class TemplateSlotErrorType < Types::BaseObject
    description <<~TEXT
    Any number of things can go awry when rendering slot templates,
    this provides insight into errors that can occur at compilation
    or render-time.
    TEXT

    field :line_number, Int, null: true do
      description <<~TEXT
      The line number where the error started (if available).
      TEXT
    end

    field :markup_context, String, null: true do
      description <<~TEXT
      The excerpt of markup that triggered the error (if available).
      TEXT
    end

    field :message, String, null: false do
      description <<~TEXT
      The description of the error.
      TEXT
    end
  end
end
