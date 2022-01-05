# frozen_string_literal: true

# A validator for ensuring that a given array has only unique items.
#
# It relies on [`Array#uniq`](https://ruby-doc.org/core-3.0.2/Array.html#method-i-uniq),
# so if checking an array of POROs, ensure that their `#eql?` methods are implemented
# correctly. (`Dry::Core::Equalizer` provides this out-of-the-box for most use cases).
class UniqueItemsValidator < ActiveModel::EachValidator
  # @param [ActiveModel::Validations, #errors] record
  # @param [Symbol] attribute
  # @param [Array, #to_a] value
  # @return [void]
  def validate_each(record, attribute, value)
    return if value.blank?

    arr = Array(value)

    unique_count = arr.uniq.size

    total_count = arr.size

    diff = total_count - unique_count

    record.errors.add attribute, "has #{diff} duplicate #{'item'.pluralize(diff)}" unless diff.zero?
  end
end
