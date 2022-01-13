# frozen_string_literal: true

# @abstract The base model for WDP-API.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include ArelHelpers
  include AssociationHelpers
  include DerivedGraphqlTypes
  include LimitToOne
  include PostgresEnums
  include StoreModelIntrospection
  include WhereMatches

  def call_operation(name, *args)
    WDPAPI::Container[name].call(*args)
  end

  # Quote the model's primary key if it is persisted and a single string.
  #
  # @return [String, nil]
  def quoted_id
    self.class.connection.quote id if persisted? && id.kind_of?(String)
  end

  # Generate a GUID for use with GraphQL / Relay for a persisted model.
  #
  # @see RelayNode::IdFromObject
  # @return [String, nil] the Relay-acc
  def to_encoded_id
    call_operation("relay_node.id_from_object", self).value! if persisted?
  end

  class << self
    # @note Only in tests
    def default_factory
      model_name.i18n_key
    end

    def arel_text_contains(field, value)
      arel_table[field].matches("%#{escape_ilike_needle(value)}%")
    end

    def escape_ilike_needle(needle)
      needle.gsub("%", "\\%").gsub("_", "\\_")
    end

    def find_graphql_slug(slug)
      id = WDPAPI::Container["slugs.decode_id"].call(slug).value!

      find id
    end

    def quoted_ids
      ids.map { |id| connection.quote id }
    end

    def sample(num = nil)
      randomized = reorder(Arel.sql("RANDOM()"))

      if num.is_a?(Integer) && num >= 1
        randomized.limit(num)
      else
        randomized.first
      end
    end
  end
end
