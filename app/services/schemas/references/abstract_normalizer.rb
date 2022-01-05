# frozen_string_literal: true

module Schemas
  module References
    # @abstract
    class AbstractNormalizer
      # @!parse [ruby]
      #   # @param [<Class>] models
      #   def initialize(models:)
      #     @models = models
      #   end
      #
      #   # @!attribute [r] models
      #   # An array of classes that inherit from {ActiveRecord::Base}.
      #   # @return [<Class>]
      #   attr_reader :models
      include Dry::Initializer[undefined: false].define -> do
        option :models, type: AppTypes::ModelClassList.constrained(min_size: 1)
      end

      include WDPAPI::Deps[object_from_id: "relay_node.object_from_id"]
    end
  end
end
