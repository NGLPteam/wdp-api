# frozen_string_literal: true

module Harvesting
  module Extraction
    # @see Harvesting::Extraction::MappingTemplateValidator
    class ValidateMappingTemplate < Support::SimpleServiceOperation
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      service_klass Harvesting::Extraction::MappingTemplateValidator
    end
  end
end
