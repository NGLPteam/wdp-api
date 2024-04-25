# frozen_string_literal: true

module Support
  module HandlesModelName
    # @return [ActiveModel::Name]
    def model_name_from(model_name)
      return model_name.model_name if model_name.respond_to? :model_name

      ActiveModel::Name.new(nil, nil, model_name)
    end
  end
end
