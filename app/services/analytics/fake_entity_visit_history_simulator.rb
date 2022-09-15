# frozen_string_literal: true

module Analytics
  # @api private
  class FakeEntityVisitHistorySimulator
    extend Dry::Core::Cache

    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      param :entity, Analytics::Types::Entity

      option :user, Analytics::Types::User, default: proc { AnonymousUser.new }
      option :ip, Analytics::Types::String, default: proc { WDPAPI::Container["testing.random_ip_address"].call }
      option :user_agent, Analytics::Types::String, default: proc { Faker::Internet.user_agent }
    end

    include WDPAPI::Deps[
      build_fake_tracker: "analytics.build_fake_tracker",
    ]

    attr_reader :ahoy

    # @return [void]
    def generate!
      start = all_times.min

      visit_entity! start, all_times

      return
    end

    private

    # @param [Time] start
    # @param [<Time>] times
    def visit_entity!(start, times)
      @ahoy = build_fake_tracker.(ip: ip, user: user, user_agent: user_agent)

      @visit_id = upsert_visit!(started_at: start)

      @events = []

      times.each do |time|
        events_for! time
      end

      Ahoy::Event.with_advisory_lock("events/#{@visit_id}") do
        Ahoy::Event.insert_all(@events, returning: nil)
      end
    ensure
      @visit_id = nil
      @events = nil
      @ahoy = nil
    end

    def events_for!(time)
      @current_time = time

      add_event! "entity.view"

      assets_to_sample do |asset, download_time|
        add_event! "asset.download", subject: asset, time: download_time
      end
    ensure
      @current_time = nil
    end

    memoize def all_times
      Testing::FakeTimesGenerator.new(
        range_start: entity.created_at.to_date,
        initial_start_time: entity.created_at,
        times_per_day_min: 1,
        times_per_day_max: 5
      ).call
    end

    memoize def download_times
      size = all_times.size

      fraction = size * Rational(60, 100)

      download_count = fraction.ceil

      all_times.sample(download_count).sort
    end

    memoize def asset_count
      entity.assets.count
    end

    # Always download 50% of assets at appropriate times
    memoize def asset_sample_size
      return 0 unless has_assets?

      asset_count.fdiv(2).ceil
    end

    def has_assets?
      asset_count > 0
    end

    def add_event!(...)
      @events << build_event(...)
    end

    # @param [Time] started_at
    # @return [String]
    def upsert_visit!(started_at:)
      fetch_or_store("visit", @ahoy.visit_token) do
        Ahoy::Visit.with_advisory_lock("visits/#{@ahoy.visit_token}") do
          filtered_attributes = @ahoy.visit_properties.slice(*Ahoy::Visit.column_names.map(&:to_sym))

          attributes = {
            visit_token: @ahoy.visit_token,
            visitor_token: @ahoy.visitor_token,
            started_at: started_at,
          }.reverse_merge(filtered_attributes)

          result = Ahoy::Visit.upsert(
            attributes,
            unique_by: :visit_token,
            returning: :id,
          )

          # :nocov:
          Ahoy::GeocodeV2Job.perform_later @ahoy.visit_token, attributes[:ip] if Ahoy.geocode && attributes[:ip].present?
          # :nocov:

          result.pick("id")
        end
      end
    end

    def build_event(name, time: @current_time, subject: nil, **properties)
      properties[:fake] = true

      {
        visit_id: @visit_id,
        user_id: nil,
        name: name,
        time: time,
        subject_type: nil,
        subject_id: nil,
      }.tap do |h|
        h[:entity_type] = entity.model_name.to_s
        h[:entity_id] = entity.id

        if subject.present?
          h[:subject_type] = subject.model_name.to_s
          h[:subject_id] = subject.id
        end

        h[:properties] = properties
      end
    end

    def assets_to_sample
      return unless has_assets? && @current_time.in?(download_times)

      entity.assets.sample(asset_sample_size).each_with_index do |asset, index|
        offset = 1 + index
        offset *= 3
        offset += 10

        download_time = @current_time + offset.seconds

        yield asset, download_time
      end
    end
  end
end
