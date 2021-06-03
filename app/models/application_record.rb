# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include DerivedGraphqlTypes
  include WhereMatches

  # @return [String]
  def to_encoded_id
    WDPAPI::Container["relay_node.id_from_object"].call(self).value! if persisted?
  end

  class << self
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

    # @return [void]
    def pg_enum!(attr_name, as:, **options)
      values = pg_enum_values(as).to_h { |v| [v, v] }

      enum options.merge attr_name => values
    end

    def sample(num = nil)
      randomized = reorder(Arel.sql("RANDOM()"))

      if num.is_a?(Integer) && num >= 1
        randomized.limit(num)
      else
        randomized.first
      end
    end

    private

    def pg_enum_values(enum_name)
      schema = Rails.root.join("db/schema.rb").read
      matched = schema.match(/create_enum .#{enum_name}.?, \[([^\]]*)\]/m)
      matched[1].tr(" \n\"", "").split(",").map(&:to_s)
    end
  end
end
