# frozen_string_literal: true

# Resolvers work in concert with {Loaders} to provide filtering and sorting
# to collections of models. Most connections in the GraphQL API have an
# underlying resolver, which has the responsibility of not only handling
# filtering but also making sure that associations that are likely to be
# consumed by the client are eager-loaded to cut down on N+1 issues as much
# as possible.
#
# @subsystem GraphQL
module Resolvers
end
