# frozen_string_literal: true

module WhereMatches
  extend ActiveSupport::Concern

  class_methods do
    def where_matches(_wildcard: false, _escape: true, **pairs)
      pairs.reduce(all) do |scope, (column, value)|
        next scope if value.blank?

        conditions =
          if value.kind_of?(Array)
            expressions = value.map do |actual_value|
              arel_table[column].matches(wrap_like_value_in_wildcard(actual_value, _wildcard, escape: _escape))
            end

            arel_or_expressions(*expressions)
          else
            arel_table[column].matches(wrap_like_value_in_wildcard(value, _wildcard, escape: _escape))
          end

        scope.where conditions
      end
    end

    def where_like(_wildcard: :both, **pairs)
      where_matches(**pairs.merge(_wildcard: _wildcard))
    end

    def where_contains(**pairs)
      where_matches _wildcard: :both, **pairs
    end

    def where_begins_like(**pairs)
      where_matches _wildcard: :end, **pairs
    end

    def where_ends_like(**pairs)
      where_matches _wildcard: :start, **pairs
    end

    private

    def wrap_like_value_in_wildcard(value, wildcard_type = :both, escape: true)
      needle = escape ? value.to_s.gsub(?%, "\\%").gsub(?_, "\\_") : value

      case wildcard_type
      when :start
        "%#{needle}"
      when :end
        "#{needle}%"
      when :both
        "%#{needle}%"
      else
        needle.to_s
      end
    end
  end
end
