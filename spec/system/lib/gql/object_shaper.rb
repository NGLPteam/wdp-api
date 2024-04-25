# frozen_string_literal: true

module Testing
  module GQL
    class ObjectShaper
      include BuildableObject

      def initialize(**pairs)
        pairs.each do |k, v|
          self[k] = v
        end
      end
    end
  end
end
