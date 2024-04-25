# frozen_string_literal: true

module Support
  module Models
    # Match whether a provided model conforms to expectations.
    #
    # @see Support::Models::Validator
    # @operation
    class Matches
      extend Dry::Core::Cache

      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      # @param [ApplicationRecord, nil] model
      # @param [Models::Types::ModelClassList] allowed
      # @return (see Models::Matcher#call)
      def call(model, allowed:)
        validator_for(allowed).call(model)
      end

      private

      def validator_for(models, **options)
        models = [models] unless models.kind_of?(Array)

        fetch_or_store models do
          Models::Validator.new models
        end
      end
    end
  end
end
