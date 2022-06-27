# frozen_string_literal: true

module WhereMatches
  extend ActiveSupport::Concern

  class_methods do
    def where_matches(_wildcard: false, _escape: true, _case_sensitive: false, _or: false, **pairs)
      counter = 0

      pairs.reduce(all) do |scope, (column, value)|
        counter += 1

        next scope if value.blank?

        conditions = arel_or_expressions value do |actual_value|
          needle = wrap_like_value_in_wildcard(actual_value, _wildcard, escape: _escape)

          arel_table[column].matches(needle, nil, _case_sensitive)
        end

        if _or && counter > 1
          scope.or(scope.unscoped.where(conditions))
        else
          scope.where conditions
        end
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
