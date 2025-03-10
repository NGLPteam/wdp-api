# frozen_string_literal: true

module Harvesting
  module Testing
    module OAI
      # @api private
      # @see Harvesting::Testing::OAI::ModelWrapper
      class Constraints
        MIN_TIME = ::Time.iso8601("1800-01-01T00:00:00+00:00")
        MAX_TIME = ::Time.iso8601("3000-01-01T00:00:00+00:00")

        include Dry::Initializer[undefined: false].define -> do
          option :model, Harvesting::Testing::Types::OAIRecordKlass
          option :identifier_field, Harvesting::Testing::Types::Coercible::String, default: proc { model.primary_key || "identifier" }
          option :metadata_prefix, Harvesting::Types::String, default: proc { "jats" }
          option :timestamp_field, Harvesting::Testing::Types::Coercible::String, default: proc { "changed_at" }
          option :earliest, Harvesting::Testing::Types::Params::Time, default: proc { MIN_TIME }
          option :latest, Harvesting::Testing::Types::Params::Time, default: proc { MAX_TIME }
          option :limit, Harvesting::Testing::Types::Limit, default: proc { Harvesting::Testing::Types::LIMIT_DEFAULT }

          option :resumption_token, Harvesting::Testing::Types::String.optional, as: :token_string, optional: true

          option :from, Harvesting::Testing::Types::Params::Time.optional, as: :from_time, optional: true
          option :until, Harvesting::Testing::Types::Params::Time.optional, as: :until_time, optional: true
          option :set, Harvesting::Testing::Types::String.optional, optional: true
          option :token, Harvesting::Testing::Types::OAIResumptiontoken.optional, default: proc { ::OAI::Provider::ResumptionToken.parse(token_string) if token_string.present? }
          option :last_id, Harvesting::Testing::Types::String.optional, default: proc { token.try(:last_str) }
        end

        # @return [FrozenRecord::Scope]
        attr_reader :base_scope

        # @return [::OAI::Provider::ResumptionToken]
        attr_reader :initial_token

        # @return [Range(Time), nil]
        attr_reader :range

        # @return [FrozenRecord::Scope]
        attr_reader :scope

        # @return [Integer]
        attr_reader :total

        def initialize(...)
          super

          @range = build_range

          @conditions = build_conditions

          @base_scope = build_base_scope

          @scope = build_scope

          @total = base_scope.count

          @initial_token = build_initial_token
        end

        # @param [String, :all] selector
        # @return [::OAI::Provider::PartialResult, FrozenRecord::Scope, FrozenRecord::Base, nil]
        def find(selector)
          return next_page if has_provided_token?

          if selector == :all
            total = scope.count

            if total > limit
              select_partial(current_token: initial_token)
            else
              scope.all
            end
          else
            scope.find_by(identifier_field => selector)
          end
        end

        # @!group Checks

        def any_time_provided?
          from_provided? || until_provided?
        end

        def both_times_provided?
          from_provided? && until_provided?
        end

        def from_provided?
          from_time.present?
        end

        def has_provided_token?
          token_string.present? && token.present?
        end

        def until_provided?
          until_time.present?
        end

        def valid?
          return true unless both_times_provided?

          from_time <= until_time
        end

        # @!endgroup

        private

        # @return [FrozenRecord::Scope]
        def build_base_scope
          model
            .in_provider_order
            .by_set(set)
            .where(@conditions)
        end

        # @return [Hash]
        def build_conditions
          {}.tap do |c|
            c[timestamp_field] = range if range.present?
          end.symbolize_keys.freeze
        end

        def build_initial_token
          options = {
            metadata_prefix:,
            set:,
            last: 0,
            from: from_time,
            until: until_time,
          }

          ::OAI::Provider::ResumptionToken.new(options, nil, total)
        end

        # @return [Range(Time), nil]
        def build_range
          return unless any_time_provided? && valid?

          start = [from_time, earliest].compact.max
          close = [until_time, latest].compact.min

          start..close
        end

        # @return [FrozenRecord::Scope]
        def build_scope
          base_scope.since_identifier(last_id)
        end

        # @return [::OAI::Provider::PartialResult, nil]
        def select_partial(current_token: token || initial_token)
          records = scope.limit(limit).to_a

          page_total = scope.count

          offset = limit >= page_total ? nil : records.last.try(identifier_field)

          ::OAI::Provider::PartialResult.new(records, current_token.next(offset))
        end

        def next_page
          select_partial(current_token: token)
        end
      end
    end
  end
end
