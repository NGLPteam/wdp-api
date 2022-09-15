# frozen_string_literal: true

module Testing
  # Populate our set of random ip addresses for US-based IPs that have an associated region code.
  #
  # @see Testing::CountryAddressGenerator
  # @see Testing::RandomIPAddressSet
  class GenerateRandomIPAddresses
    include Dry::Monads[:result]

    def call
      set = Testing::RandomIPAddressSet.instance

      generator = Testing::CountryAddressGenerator.new "United States", desired: 2000, require_region_code: true

      addresses = generator.call

      set.write! addresses

      Success addresses.size
    end
  end
end
