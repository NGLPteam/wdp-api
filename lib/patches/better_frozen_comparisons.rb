# frozen_string_literal: true

module Patches
  module FrozenFuzzyMatch
    def match?(other)
      if compare_hash?(@value, other)
        maybe_compare_hash(@value, other)
      else
        super
      end
    end

    private

    def compare_hash?(left, right)
      left.kind_of?(Hash) && left.present? && right.kind_of?(Hash)
    end

    def maybe_compare_hash(left, right)
      catch(:no_match) do
        left.each do |key, left_value|
          if right.key?(key)
            right_value = right[key]

            matched =
              if compare_hash?(left_value, right_value)
                maybe_compare_hash(left_value, right_value)
              else
                left_value == right_value
              end

            throw :no_match, false unless matched
          end
        end

        true
      end
    end
  end
end

FrozenRecord::Scope::Matcher.prepend Patches::FrozenFuzzyMatch
