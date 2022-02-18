# frozen_string_literal: true

module Schemas
  module Properties
    module Scalar
      # Validate a property type that implements min/max size ranges.
      module ValidatesSizeSanity
        extend ActiveSupport::Concern

        included do
          validate :min_and_max_size_are_sane!
        end

        # @api private
        # @return [void]
        def min_and_max_size_are_sane!
          return if min_size.blank? || max_size.blank?

          return if min_size < max_size

          errors.add :base, "`min_size` (#{min_size}) must be less than `max_size` (#{max_size})"
        end
      end
    end
  end
end
