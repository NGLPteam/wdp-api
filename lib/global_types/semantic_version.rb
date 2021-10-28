# frozen_string_literal: true

module GlobalTypes
  # Wrapper around a semantic version
  class SemanticVersion < ActiveRecord::Type::String
    VERSION_HASH = Dry::Types["hash"].schema(
      major: Dry::Types["coercible.integer"],
      minor: Dry::Types["coercible.integer"],
      patch: Dry::Types["coercible.integer"],
      pre: Dry::Types["string"].optional,
      build: Dry::Types["string"].optional,
    ).with_key_transform(&:to_sym)

    # Type cast a value from user input (e.g. from a setter).
    #
    # @param [Hash, #to_h] value
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def cast(value)
      case value
      when String
        Semantic::Version.new(value)
      when VERSION_HASH
        cast version_string_from(**VERSION_HASH[value])
      else
        super
      end
    rescue ArgumentError
      nil
    end

    def serialize(value)
      value.nil? ? super : super(value.to_s)
    end

    def type
      :semantic_version
    end

    private

    def version_string_from(major:, minor:, patch:, pre: nil, build: nil)
      [major, minor, patch].join(?.).then do |version|
        pre.present? ? "#{version}-#{pre}" : version
      end.then do |version|
        build.present? ? "#{version}+#{build}" : version
      end
    end
  end
end
