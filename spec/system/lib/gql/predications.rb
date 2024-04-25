# frozen_string_literal: true

module Testing
  module GQL
    # Expose RSpec predicates within the code for generating GQL shapes.
    module Predications
      extend ActiveSupport::Concern

      def be_blank
        @be_blank ||= RSpec::Matchers::BuiltIn::BePredicate.new :be_blank
      end
    end
  end
end
