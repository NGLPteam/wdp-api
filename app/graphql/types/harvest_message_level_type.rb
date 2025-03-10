# frozen_string_literal: true

module Types
  class HarvestMessageLevelType < Types::BaseEnum
    description <<~TEXT
    Levels of severity associated with `HarvestMessage`s.

    `FATAL` is the most severe, `TRACE` is the least.
    TEXT

    value "FATAL", value: "fatal" do
      description <<~TEXT
      A fatal error which likely caused an entire harvesting operation to stop.
      TEXT
    end

    value "ERROR", value: "error" do
      description <<~TEXT
      An error that may or may not have interrupted a harvesting operation,
      but could, for instance, just indicate that a single record failed.
      TEXT
    end

    value "WARN", value: "warn" do
      description <<~TEXT
      Warnings about validation failures and similar things.
      TEXT
    end

    value "INFO", value: "info" do
      description <<~TEXT
      Informational messages that are higher priority than debug messages.
      TEXT
    end

    value "DEBUG", value: "debug" do
      description <<~TEXT
      Debug information about the harvesting system.

      May be hidden by default when displaying.
      TEXT
    end

    value "TRACE", value: "trace" do
      description <<~TEXT
      Very low-level trace messages that may be used in the future
      to narrow down specific / performance issues with harvesting,
      but at present likely won't appear.

      Should be hidden by default when displaying.
      TEXT
    end
  end
end
