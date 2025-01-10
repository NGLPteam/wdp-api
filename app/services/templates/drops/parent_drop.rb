# frozen_string_literal: true

module Templates
  module Drops
    # A wrapper around a {HierarchicalEntity} that only exposes core props.
    class ParentDrop < Templates::Drops::AbstractEntityDrop
      # @note When rendering a parent in liquid assigns, we do not
      #   allow it to access props since there's no reasonable way
      #   to guarantee which schema the parent might be, and we
      #   do not want lots of introspection in templates.
      def props
        # :nocov:
        raise Liquid::ContextError, "cannot fetch props for entity parent"
        # :nocov:
      end
    end
  end
end
