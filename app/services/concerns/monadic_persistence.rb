# frozen_string_literal: true

module MonadicPersistence
  extend ActiveSupport::Concern

  def monadic_save(model)
    if model.save
      Dry::Monads.Success(model)
    else
      Dry::Monads::Result::Failure[:invalid, model]
    end
  end
end
