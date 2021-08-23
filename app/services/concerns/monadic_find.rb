# frozen_string_literal: true

module MonadicFind
  extend ActiveSupport::Concern

  def monadic_find(model_klass, *primary_key)
    model = model_klass.find(*primary_key)
  rescue ActiveRecord::RecordNotFound => e
    Dry::Monads::Result::Failure[:record_not_found, e.message]
  else
    Dry::Monads.Success model
  end

  def monadic_find_by(model_klass, **conditions)
    model = model_klass.find_by! conditions
  rescue ActiveRecord::RecordNotFound => e
    Dry::Monads::Result::Failure[:record_not_found, e.message]
  else
    Dry::Monads.Success model
  end
end
