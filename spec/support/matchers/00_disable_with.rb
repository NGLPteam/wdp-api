# frozen_string_literal: true

# ActiveSupport 7.1 introduces an annoying new monkeypatch on Object, called with.
# This conflicts with helpful methods we use that are named such.

RSpec::Matchers::MatcherDelegator.undef_method(:with) rescue nil

RSpec::Matchers::DSL::Matcher.undef_method(:with) rescue nil

RSpec::Matchers::BuiltIn::BaseMatcher.undef_method(:with) rescue nil
