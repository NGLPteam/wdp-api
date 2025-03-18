# frozen_string_literal: true

Support::System.register_provider(:active_model_types) do
  start do
    ActiveModel::Type.registry.lookup :interval
  rescue ArgumentError
    ActiveModel::Type.register :interval, Support::ModelTypes::Interval
  end
end
