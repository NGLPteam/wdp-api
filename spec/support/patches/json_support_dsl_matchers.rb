# frozen_string_literal: true

module Patches
  module SupportDSLMatchers
    class << self
      def prepended(base)
        base::SUPPORTED_VALUES << RSpec::Matchers::DSL::Matcher
        base.singleton_class.prepend Patches::SupportDSLMatchers::ClassMethods
      end
    end

    module ClassMethods
      def handle_rspec_matcher(errors, expected, actual, negate = false, prefix = [])
        return nil unless defined?(RSpec::Matchers)
        return nil unless expected.is_a?(RSpec::Matchers::BuiltIn::BaseMatcher) ||
          expected.is_a?(RSpec::Matchers::AliasedMatcher) ||
          expected.is_a?(RSpec::Matchers::DSL::Matcher)

        if conditionally_negate(!!expected.matches?(actual), negate)
          true
        else
          errors[prefix.join("/")] = {
            actual:,
            expected: expected.description
          }
          false
        end
      end
    end
  end
end

RSpec::JsonExpectations::JsonTraverser.prepend Patches::SupportDSLMatchers
