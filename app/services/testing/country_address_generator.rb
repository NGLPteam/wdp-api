# frozen_string_literal: true

module Testing
  # Generate a set of IP addresses matching a given country (and optionally requiring a region code).
  class CountryAddressGenerator
    include Dry::Initializer[undefined: false].define -> do
      param :country_name, Testing::Types::String

      option :desired, Testing::Types::Integer.constrained(gt: 0), default: proc { 100 }

      option :max_calculation_count, Testing::Types::Integer.constrained(gt: 100), default: proc { 100_000 }

      option :require_region_code, Testing::Types::Bool, default: proc { false }
    end

    def call
      @ips = []
      @runs = 0

      loop do
        ip = Faker::Internet.unique.public_ip_v4_address

        @ips << ip if acceptable?(ip)

        break if @ips.length >= desired || @runs > max_calculation_count
      end

      return @ips
    ensure
      Faker::UniqueGenerator.clear
    end

    private

    # @param [String] ip
    def acceptable?(ip)
      found = Geocoder.search(ip)&.first

      return false unless found&.country == country_name

      if require_region_code
        found.province_code.present?
      else
        true
      end
    end
  end
end
