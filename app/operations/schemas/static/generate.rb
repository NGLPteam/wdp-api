# frozen_string_literal: true

module Schemas
  module Static
    # A container that contains schema property generation services for testing.
    class Generate
      include Dry::Container::Mixin

      def initialize
        super if defined? super

        populate!
      end

      private

      def definitions
        Schemas::Static["definitions.map"]
      end

      def populate!
        definitions.identifiers.each do |identifier|
          register identifier, generator_for(identifier)
        end
      end

      def generator_for(identifier)
        WDPAPI::Container["schemas.static.generate.#{identifier}"]
      rescue Dry::Container::Error
        Schemas::Static::Generator.new
      end
    end
  end
end
