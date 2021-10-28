# frozen_string_literal: true

module Harvesting
  # A module to be prepended in front of harvesting operations in order to make ActiveRecord a touch quieter.
  module HushActiveRecord
    def call(...)
      ApplicationRecord.logger.silence do
        super
      end
    end

    def silence_activerecord
      ApplicationRecord.logger.silence do
        yield if block_given?
      end
    end
  end
end
