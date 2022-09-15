# frozen_string_literal: true

module Testing
  # Return a random US IP address (based on a set of 2,000)
  class RandomIPAddress
    # @note For simplicity, this is non-monadic (it can't fail under any reasonable circumstance).
    # @return [String]
    def call(...)
      Testing::RandomIPAddressSet.sample(...)
    end
  end
end
