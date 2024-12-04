# frozen_string_literal: true

module Resolvers
  # @abstract
  # @note If you rely upon argument authorization, you _cannot_ use this, as it doesn't appear to work.
  #   You will need to manually build resolve a scope with something like {GraphQL::BuildableResolver}.
  class AbstractResolver < GraphQL::Schema::Resolver
    extend Dry::Core::ClassAttributes

    include SearchObject.module(:graphql)
    include GraphQL::FragmentCache::ObjectHelpers
    include Resolvers::AbstractOrdering

    argument_class ::Types::BaseArgument

    defines :filter_scope_klass, type: AppTypes.Inherits(::Filtering::FilterScope).optional

    defines :params_order, type: Support::Types::ParamsReorderer

    defines :args_to_hash, type: Support::Types::Array.of(Support::Types::Coercible::Symbol)

    args_to_hash [].freeze

    params_order Support::Params::Reorderer.default

    # @note Expose the SearchObject::Search object.
    attr_reader :search

    # @return [User, AnonymousUser]
    attr_reader :current_user

    delegate :has_admin_access?, to: :current_user, allow_nil: true

    def initialize(...)
      super

      reorder_search_params!

      @current_user = context&.[](:current_user) || AnonymousUser.new
    end

    def params=(params)
      super

      reorder_search_params!
    end

    # @!group Enhanced Introspection

    # @return [Integer]
    def count
      @count ||= fetch_count
    end

    # @return [ActiveRecord::Relation]
    def raw_scope
      @search.instance_variable_get(:@scope)
    end

    # @return [Integer]
    def unfiltered_count
      @unfiltered_count ||= fetch_unfiltered_count
    end

    # @return [ActiveRecord::Relation]
    def unfiltered_scope
      raw_scope
    end

    # @!endgroup

    # @!group Filtering

    # @see Types::FilterInputObject#prepare
    # @param [ActiveRecord::Relation] scope
    # @param [Filtering::FilterScope, nil] filters the filtered result (if present)
    # @return [ActiveRecord::Relation]
    def apply_filters(scope, filters)
      unless filters.nil?
        filters.apply_to scope
      else
        scope.all
      end
    end

    # @see Types::FilterInputObject#prepare
    # @param [ActiveRecord::Relation] scope
    # @param [<Filtering::FilterScope, nil>] values the filtered results (if present)
    # @return [ActiveRecord::Relation]
    def apply_or_filters(scope, values)
      first, *rest = values.compact.map(&:call)

      return scope.all if first.nil?

      base = scope.where(id: first)

      return base if rest.blank?

      rest.reduce base do |sc, value|
        sc.or(scope.where(id: value))
      end
    end

    # @!endgroup

    # @!group Caching

    # @param [{ Symbol => Object }] args
    # @return [Integer]
    def arg_hash_from(args)
      args_to_hash(args).hash
    end

    # @api private
    # @param [{ Symbol => Object }] args
    # @return [Hash]
    def args_to_hash(args)
      self.class.args_to_hash.index_with { args[_1] }
    end

    # @!endgroup

    private

    # @return [Integer]
    def fetch_count
      fetch_results.count_from_subquery
    end

    # @return [Integer]
    def fetch_unfiltered_count
      unfiltered_scope.count_from_subquery
    end

    # @return [void]
    def reorder_search_params!
      new_params = self.class.params_order.(@search.params)

      @search.instance_variable_set(:@params, new_params)
    end

    class << self
      # @param [Class<Filtering::FilterScope>] filter_scope
      # @return [void]
      def filters_with!(filter_scope)
        filter_scope_klass filter_scope

        options = filter_scope.options_for_resolver.merge(with: :apply_filters)
        or_options = filter_scope.options_for_or_resolver.merge(with: :apply_or_filters)

        option :filters, **options
        option :or_filters, **or_options
      end

      # @param [<Symbol>] args
      # @return [void]
      def hashes_args!(*args)
        new_args = args.flatten.map(&:to_sym)

        args_to_hash args_to_hash | new_args
      end

      def i18n_scope
        @i18n_scope || find_i18n_scope
      end

      def option_description_for(name)
        scope = "#{i18n_scope}.options.#{name}"

        I18n.t(:description, scope:).try(:strip)
      end

      private

      def find_i18n_scope
        infix = name.demodulize[/\A(\w+?)Resolver\z/, 1].underscore

        "gql.resolvers.#{infix}"
      end
    end
  end
end
