# frozen_string_literal: true

module Resolvers
  module Enhancements
    # A concern that ensures that a pundit policy is applied
    # to the resolver's generated scope.
    module AppliesPolicyScope
      extend ActiveSupport::Concern

      def initialize(**options)
        @object = options[:object]

        config = self.class.config

        base_scope = options[:scope] || (config[:scope] && instance_eval(&config[:scope]))

        options[:scope] = Pundit.policy_scope! options.dig(:context, :current_user), base_scope

        super
      end
    end
  end
end
