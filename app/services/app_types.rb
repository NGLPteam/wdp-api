# frozen_string_literal: true

module AppTypes
  include Dry.Types

  extend Shared::EnhancedTypes

  ISSN_PATTERN = /\A\d{4}-\d{4}\z/

  ISSN = String.constrained(format: ISSN_PATTERN)

  MIME = Instance(::MIME::Type).constructor do |input|
    case input
    when "audio/mp3"
      ::MIME::Types["audio/mpeg"].first
    when ::String
      ::MIME::Types[input].first
    end
  end.fallback do
    ::MIME::Types["application/octet-stream"].first
  end

  SemanticVersion = Constructor(Semantic::Version) do |input|
    raise Dry::Types::ConstraintError.new(nil, input) if input.blank?

    Semantic::Version.new input.to_s
  rescue ArgumentError => e
    raise Dry::Types::ConstraintError.new e.message, input
  end
end
