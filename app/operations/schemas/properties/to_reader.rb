# frozen_string_literal: true

module Schemas
  module Properties
    class ToReader
      include Dry::Monads[:do, :result]

      # @param [{ Symbol => Object }] base_options
      # @option base_options [Schemas::Properties::Context] :context
      # @return [Dry::Monads::Result(Schemas::Properties::Reader, Schemas::Properties::GroupReader)]
      def call(property, **base_options)
        options = {}.merge(base_options).compact

        if property.group?
          compile_group property, options
        else
          compile_property property, options
        end
      end

      private

      def compile_group(group, **base_options)
        options = base_options.merge(group: group)

        options[:properties] = group.properties.map do |property|
          yield compile_property property, options
        end

        Success Schemas::Properties::GroupReader.new options
      end

      def compile_property(property, **base_options)
        options = base_options.merge(property: property)

        Success Schemas::Properties::Reader.new options
      end
    end
  end
end
