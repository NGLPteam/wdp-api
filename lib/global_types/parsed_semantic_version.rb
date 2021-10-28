# frozen_string_literal: true

require_relative "../variable_precision_date"

module GlobalTypes
  class ParsedSemanticVersion < ActiveRecord::Type::Value
    ENCODER = PG::TextEncoder::Record.new
    DECODER = PG::TextDecoder::Record.new

    ENCODED = /\A\((?:"?\d*"?),(?:"?\d*"?),(?:"?\d*"?),(?:"?[^,]*"?),(?:"?[^,]*"?)\)\z/.freeze

    VERSION_HASH = Dry::Types["hash"].schema(
      major: Dry::Types["coercible.integer"],
      minor: Dry::Types["coercible.integer"],
      patch: Dry::Types["coercible.integer"],
      pre: Dry::Types["string"].optional,
      build: Dry::Types["string"].optional,
    ).with_key_transform(&:to_sym)

    # @param [String] value
    # @return [VariablePrecisionDate]
    def cast(value)
      case value
      when ENCODED
        decode_semantic_version value
      when String
        Semantic::Version.new value
      when Semantic::Version
        value
      when VERSION_HASH
        cast version_string_from(**VERSION_HASH[value])
      end
    end

    # @param [VariablePrecisionDate] new_value
    # @return [String] the SQL representation of the variable precision date (e.g. `(2021-01-01,year)`)
    def serialize(value)
      case value
      when Semantic::Version
        ENCODER.encode value.to_array
      end
    end

    # @param [String] raw_old_value
    # @param [VariablePrecisionDate] new_value
    def changed_in_place?(raw_old_value, new_value)
      raw_old_value != serialize(new_value)
    end

    def type
      :parsed_semantic_version
    end

    private

    def decode_semantic_version(value)
      major, minor, patch, pre, build = DECODER.decode value

      version_string = version_string_from major: major, minor: minor, patch: patch, pre: pre, build: build

      Semantic::Version.new version_string
    end

    def version_string_from(major:, minor:, patch:, pre: nil, build: nil)
      [major, minor, patch].join(?.).then do |version|
        pre.present? ? "#{version}-#{pre}" : version
      end.then do |version|
        build.present? ? "#{version}+#{build}" : version
      end
    end
  end
end
