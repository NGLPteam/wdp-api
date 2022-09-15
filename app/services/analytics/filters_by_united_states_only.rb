# frozen_string_literal: true

module Analytics
  module FiltersByUnitedStatesOnly
    extend ActiveSupport::Concern

    included do
      option :us_only, Analytics::Types::Bool.fallback(false), default: proc { false }

      before_prepare :join_visit!

      before_build :filter_by_us_only!
    end

    # @return [void]
    def join_visit!
      augment_scope! do |scope|
        scope.joins(:visit)
      end
    end

    # @return [void]
    def filter_by_us_only!
      augment_scope! do |scope|
        scope.merge(Ahoy::Visit.where(country_code: "US")) if us_only
      end
    end
  end
end
