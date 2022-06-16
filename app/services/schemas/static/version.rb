# frozen_string_literal: true

module Schemas
  module Static
    # @abstract
    class Version
      extend Dry::Initializer

      include Comparable
      include Dry::Core::Memoizable
      include Dry::Core::Equalizer.new(:name, :version, immutable: true, inspect: false)
      include Dry::Monads[:result]

      param :name, AppTypes::String
      param :version, AppTypes::SemanticVersion
      param :path, AppTypes.Instance(Pathname)

      option :namespace, AppTypes::String.optional, default: proc {}

      delegate :[], :dig, :slice, to: :raw_data

      # @note Sorts in reverse order, so latest version will be at the top.
      def <=>(other)
        raise TypeError, "cannot compare with #{other.inspect}" unless other.instance_of?(self.class)

        other.version <=> version
      end

      memoize def raw_data
        JSON.parse(path.read).with_indifferent_access
      end
    end
  end
end
