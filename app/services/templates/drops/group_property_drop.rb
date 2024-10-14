# frozen_string_literal: true

module Templates
  module Drops
    class GroupPropertyDrop < Templates::Drops::AbstractDrop
      # @param [Schemas::Properties::GroupReader] reader
      def initialize(reader)
        super()

        @reader = reader

        @prop_drops = props_to_drops(@reader.properties)
      end

      def liquid_method_missing(name)
        @prop_drops.fetch(name) do
          raise Liquid::UndefinedDropMethod, "unknown nested entity property: #{@reader.path}.#{name}"
        end
      end

      def to_s
        raise "Tried to render group property #{@reader.path.inspect} in scalar context"
      end
    end
  end
end
