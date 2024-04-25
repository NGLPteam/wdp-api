# frozen_string_literal: true

module Testing
  module GQL
    # @see Testing::Requests::Build
    class RequestTester < Dry::Struct
      attribute :effects, Dry::Types["array"].optional
      attribute :expectation, Dry::Types["any"].optional
      attribute :data, Dry::Types["any"].optional
      attribute :top_level_errors, Dry::Types["any"].optional

      def has_data?
        data.present?
      end

      def has_expectation?
        !expectation.nil?
      end

      def has_top_level_errors?
        top_level_errors.present?
      end

      # @return [Hash]
      def inferred_options
        { no_top_level_errors: }
      end

      # @return [Boolean]
      def no_top_level_errors
        !has_top_level_errors?
      end
    end
  end
end
