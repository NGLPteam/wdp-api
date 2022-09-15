# frozen_string_literal: true

module Testing
  # A file-backed set of random IP addresses.
  class RandomIPAddressSet
    include Dry::Core::Memoizable
    include Enumerable

    PATH = Rails.root.join("vendor", "random_ip_addresses.yaml")

    delegate :each, :sample, :size, to: :addresses

    def addresses
      cache.compute_if_absent __method__ do
        YAML.load_file PATH
      end
    end

    # @param [<String>] addresses
    # @return [void]
    def write!(addresses)
      PATH.open "w+" do |f|
        f.write(<<~DISCLAIMER)
        # The following IP addresses are randomly generated and used for testing purposes only.
        DISCLAIMER

        f.write YAML.dump addresses
      end

      reload!
    end

    private

    memoize def cache
      Concurrent::Map.new
    end

    # @return [void]
    def reload!
      cache.clear

      return self
    end

    class << self
      def instance
        @instance ||= new
      end

      delegate_missing_to :instance
    end
  end
end
