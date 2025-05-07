# frozen_string_literal: true

module Harvesting
  module Metadata
    TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
      tc.add! :asset_kind, ::Assets::Types::Kind
      tc.add! :contribution_proxies, Harvesting::Metadata::Types::ContributionProxies
      tc.add! :doi, ::Entities::Types::DOI.constructor(&:presence).optional
      tc.add! :full_text_kind, ::FullText::Types::Kind
      tc.add! :metadata_mappings_match, Harvesting::Metadata::Types::MetadataMappingsMatch
      tc.add! :mime_type, ::AppTypes::MIME
      tc.add! :tag, Harvesting::Metadata::Types::Tag
      tc.add! :tag_list, Harvesting::Metadata::Types::TagList
      tc.add! :safe_boolean, Harvesting::Metadata::Types::SafeBoolean
      tc.add! :url, Harvesting::Metadata::Types::URL.optional
      tc.add! :variable_date, VariablePrecisionDate::ParseType
      tc.add! :variable_precision_date, VariablePrecisionDate::ParseType
    end
  end
end
