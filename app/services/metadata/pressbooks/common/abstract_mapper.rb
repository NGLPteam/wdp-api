# frozen_string_literal: true

module Metadata
  module Pressbooks
    module Common
      # @abstract
      class AbstractMapper < ::Metadata::Shared::AbstractMapper
        def as_json(*)
          Oj.load(to_json)
        end

        private

        # @param [Integer, String] input
        # @return [ActiveSupport::TimeWithZone]
        def parse_json_time(input)
          case input
          when Integer
            ::Time.zone.at(input)
          when String
            Dry::Types::Params::Time[input]
          end
        end
      end
    end
  end
end
