# frozen_string_literal: true

class UniqueItemsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    arr = Array(value)

    unique_count = arr.uniq.size
    total_count = arr.size

    diff = total_count - unique_count

    record.errors.add attribute, "has #{diff} duplicate #{'item'.pluralize(diff)}" unless diff.zero?
  end
end
