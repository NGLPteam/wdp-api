# frozen_string_literal: true

module HasHarvestErrors
  extend ActiveSupport::Concern

  included do
    has_many :harvest_errors, as: :source, dependent: :delete_all

    scope :sans_harvest_errors, -> { where.not(id: HarvestError.distinct.select(:source_id)) }
    scope :with_harvest_errors, -> { where(id: HarvestError.distinct.select(:source_id)) }
    scope :with_coded_harvest_errors, ->(code) { where(id: HarvestError.distinct.by_code(code).select(:source_id)) }
    scope :with_error_message, ->(needle) { where(id: HarvestError.distinct.message_contains(needle).select(:source_id)) }
  end

  # @return [void]
  def clear_harvest_errors!(*codes)
    harvest_errors.maybe_by_code(*codes).delete_all
  end

  # @param [String] code
  # @param [String] message
  # @param [Hash] flat_metadata an arg that allows a hash to be passed in a tuple straight to this method
  #   as a third positional argument and transparently merged into `metadata`.
  # @param [Hash] metadata
  # @return [void]
  def log_harvest_error!(code, message, flat_metadata = {}, **metadata)
    metadata.merge!(flat_metadata)

    harvest_errors.create!(code:, message:, metadata:)
  end
end
