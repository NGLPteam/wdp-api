# frozen_string_literal: true

module TransactionalCall
  def call(*)
    ApplicationRecord.transaction do
      super
    end
  end
end
