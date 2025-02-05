# frozen_string_literal: true

# Methods for detecting whether changes to a model are happening
# within the context of a GraphQL Mutation
#
# The predicate to use in lifecycles is {#in_graphql_mutation?}.
#
# @see Mutations.with_active
# @see Mutations::Active
module ModelMutationSupport
  extend ActiveSupport::Concern

  include Dry::Effects.Reader(:graphql_mutation_active, default: false)

  alias graphql_mutation_active? graphql_mutation_active

  # An attribute that simulates a GraphQL mutation being active for testing/console use.
  # It serves as a fallback for {#graphql_mutation_active?} in {#in_graphql_mutation?}.
  #
  # @return [Boolean]
  attr_accessor :pretend_graphql_mutation_active

  alias pretend_graphql_mutation_active? pretend_graphql_mutation_active
  alias pretending_graphql_mutation_active? pretend_graphql_mutation_active

  # This will either detect from the dry-effect or it will use {#pretend_graphql_mutation_active}
  def in_graphql_mutation?
    graphql_mutation_active? || pretend_graphql_mutation_active?
  end

  # @return [void]
  def with_active_mutation!(&)
    Mutations.with_active!(&)
  end
end
