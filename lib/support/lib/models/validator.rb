# frozen_string_literal: true

module Support
  module Models
    # Match that a provided input model is what we expect.
    #
    # @see Models::Matches
    class Validator
      include Dry::Initializer[undefined: false].define -> do
        param :models, Support::Models::Types::ModelClassList.constrained(min_size: 1)
      end

      include Dry::Monads[:result]

      # @param [ActiveRecord::Base] model
      # @return [Dry::Monads::Success(ActiveRecord::Base)]
      # @return [Dry::Monads::Failure(:is_nil)]
      # @return [Dry::Monads::Failure(:not_a_model)]
      # @return [Dry::Monads::Failure(:no_match)]
      def call(input)
        return Failure[:is_nil] if input.nil?

        return Failure[:not_a_model] unless input.kind_of?(ActiveRecord::Base)

        return Failure[:no_match] unless models.any? { |model| input.kind_of?(model) }

        Success(input)
      end

      Matcher =
        begin
          is_success = ->(result, *) { result.success? }

          is_failure_with = ->(code) do
            ->(result, *) { result.failure? && result.failure.first == code }
          end

          resolve_failure = proc {}

          cases = {}

          cases[:matches] = Dry::Matcher::Case.new(match: is_success, resolve: :value!.to_proc)

          %i[is_nil not_a_model no_match].each do |code|
            cases[code] = Dry::Matcher::Case.new(match: is_failure_with[code], resolve: resolve_failure)
          end

          Dry::Matcher.new cases
        end
    end
  end
end
