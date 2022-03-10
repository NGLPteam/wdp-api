# frozen_string_literal: true

module Harvesting
  # A module to be prepended in front of harvesting operations in order to make ActiveRecord a touch quieter.
  module HushActiveRecord
    def call(...)
      silence_activerecord do
        super
      end
    end

    def silence_activerecord
      prev_level = Shrine.logger.level

      Shrine.logger.level = :fatal

      ApplicationRecord.logger.silence do
        ApplicationJob.logger.silence do
          yield if block_given?
        end
      end
    ensure
      Shrine.logger.level = prev_level
    end
  end
end
