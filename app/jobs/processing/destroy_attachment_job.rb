# frozen_string_literal: true

module Processing
  class DestroyAttachmentJob < ApplicationJob
    queue_as :processing

    unique_job! by: :all_args

    # @return [void]
    def perform(attacher_class, data)
      attacher_class = Object.const_get(attacher_class)

      attacher = attacher_class.from_data(data)
      attacher.destroy
    end
  end
end
