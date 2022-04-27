# frozen_string_literal: true

module Entities
  # Reprocess a specific attachment derivative for an individual {HierarchicalEntity}
  class ReprocessDerivativeJob < ApplicationJob
    queue_as :processing

    discard_on NoMethodError

    retry_on Redis::TimeoutError, wait: :exponentially_longer

    unique :until_and_while_executing, lock_ttl: 10.minutes, on_conflict: :log

    around_perform do |job, block|
      Schemas::Orderings.with_disabled_refresh do
        block.call
      end
    end

    # @param [HierarchicalEntity] entity
    # @param [Symbol] name
    # @return [void]
    def perform(entity, name)
      attacher = entity.public_send(:"#{name}_attacher")

      return unless attacher.stored?

      old_derivatives = attacher.derivatives

      attacher.set_derivatives({})
      attacher.create_derivatives

      begin
        attacher.atomic_persist
        attacher.delete_derivatives(old_derivatives)
      rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
        # :nocov:
        attacher.delete_derivatives # remove orphans
        # :nocov:
      end
    end
  end
end
