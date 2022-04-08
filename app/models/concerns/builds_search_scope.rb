# frozen_string_literal: true

# A model that can build a {Searching::Scope} and serve as its origin.
module BuildsSearchScope
  extend ActiveSupport::Concern

  # @return [Searching::Scope]
  def to_search_scope(**options)
    Searching::Scope.new(**options, origin: self)
  end
end
