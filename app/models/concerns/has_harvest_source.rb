# frozen_string_literal: true

# For certain harvest models, it's useful to have a common
# interface for dealing with their {HarvestSource}.
module HasHarvestSource
  extend ActiveSupport::Concern

  included do
    delegate :build_protocol_context, to: :harvest_source
  end

  module ClassMethods
    # @param [String, HarvestSource] sourcelike
    # @return [ActiveRecord::Relation<HasHarvestSource>]
    def for_source(sourcelike)
      where(harvest_source: HarvestSource.identified_by(sourcelike).select(:id))
    end
  end
end
