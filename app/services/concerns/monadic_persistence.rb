# frozen_string_literal: true

module MonadicPersistence
  extend ActiveSupport::Concern

  # @param [ApplicationRecord] model
  # @return [Dry::Monads::Success(ApplicationRecord)]
  # @return [Dry::Monads::Failure(:invalid, ApplicationRecord, <String>)]
  def monadic_save(model)
    if model.save
      Dry::Monads.Success(model)
    else
      Dry::Monads::Result::Failure[:invalid, model, model.errors.full_messages.to_a]
    end
  end
end
