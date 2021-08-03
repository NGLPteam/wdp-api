# frozen_string_literal: true

module Schemas
  module Properties
    class GroupReader
      extend Dry::Initializer
      include Dry::Core::Equalizer.new(:path)

      option :group, AppTypes.Instance(Schemas::Properties::GroupDefinition)
      option :context, AppTypes.Instance(Schemas::Properties::Context), default: proc { Schemas::Properties::Context.new }
      option :properties, AppTypes::Array.of(AppTypes.Instance(Schemas::Properties::Reader)), default: proc { [] }

      delegate :legend, :full_path, :path, :required, to: :group

      # @return [Class]
      def graphql_object_type
        ::Types::Schematic::GroupPropertyType
      end

      def required
        group.required?
      end
    end
  end
end
