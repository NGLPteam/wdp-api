# frozen_string_literal: true

# Loaders are used by the GraphQL schema to avoid N+1 and other such performance issues
# since queries can potentially load many levels of models and their associations within
# the same request.
#
# @subsystem GraphQL
module Loaders
end
