# frozen_string_literal: true

module Templates
  module Config
    module Utility
      # An error raised when a root has been provided that is not in
      # the accepted mapping.
      class UnacceptableTemplateError < PolymorphicTemplateError
        # @return [Integer]
        attr_accessor :index

        # @return [Layouts::Types::Kind]
        attr_reader :layout_kind

        # @return [String]
        attr_reader :root

        def initialize(root, layout_kind: "unknown", index: 0)
          @root = root
          @index = index

          super("Layout(#{layout_kind.inspect}) does not accept templates named #{root.inspect} (index #{index})")
        end
      end
    end
  end
end
