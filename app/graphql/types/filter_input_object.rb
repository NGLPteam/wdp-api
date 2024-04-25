# frozen_string_literal: true

module Types
  # @abstract For input objects that should automatically become hashes.
  class FilterInputObject < Types::BaseInputObject
    # @return [Filtering::FilterScope, nil]
    def prepare
      options = to_h.symbolize_keys.compact.presence

      return nil if options.nil?

      self.class.filter_scope.new(**options)
    end

    class << self
      attr_reader :filter_scope

      # @param [Class<Filtering::FilterScope>] filter_scope
      # @return [void]
      def inherit_from!(filter_scope)
        @filter_scope = filter_scope

        filter_scope.arguments.each do |key, dry_type|
          typing = dry_type.gql_typing

          input_key = typing.input_key_for key

          opts = typing.argument_options

          opts[:as] = key.to_sym

          type = opts.delete :type

          argument input_key, type, **opts
        end

        model = filter_scope.model_klass

        graphql_name filter_scope.input_object_name

        description <<~TEXT
        Filters for #{model.model_name}.
        TEXT
      end
    end
  end
end
