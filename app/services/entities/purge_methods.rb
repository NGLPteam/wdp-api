# frozen_string_literal: true

module Entities
  module PurgeMethods
    extend ActiveSupport::Concern

    def finalize_for(entity)
      case mode
      when :mark
        entity.update_column(:marked_for_purge, true)
      else
        entity.destroy!
      end

      Success()
    rescue ActiveRecord::RecordNotFound
      # :nocov:
      # The record has already been destroyed by other processes
      Success()
      # :nocov:
    end
  end
end
