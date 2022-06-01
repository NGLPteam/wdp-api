# frozen_string_literal: true

module HasHarvestErrors
  extend ActiveSupport::Concern

  included do
    has_many :harvest_errors, as: :source, dependent: :delete_all

    scope :sans_harvest_errors, -> { where.not(id: HarvestError.distinct.select(:source_id)) }
    scope :with_harvest_errors, -> { where(id: HarvestError.distinct.select(:source_id)) }
    scope :with_coded_harvest_errors, ->(code) { where(id: HarvestError.distinct.by_code(code).select(:source_id)) }
  end

  # @return [void]
  def clear_harvest_errors!
    harvest_errors.delete_all
  end

  # @param [String] code
  # @param [String] message
  # @param [Hash] metadata
  # @return [void]
  def log_harvest_error!(code, message, **metadata)
    harvest_errors.create!(code: code, message: message, metadata: metadata)
  end
end
