# frozen_string_literal: true

module Types
  module DestroyMutationPayloadType
    include Types::BaseInterface
    include Types::StandardMutationPayload

    description "This mutation destroys a model"

    field :destroyed, Boolean, null: true,
      description: "Whether or not the model was successfully destroyed. If false, check globalErrors"
  end
end
