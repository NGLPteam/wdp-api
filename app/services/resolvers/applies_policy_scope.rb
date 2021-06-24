# frozen_string_literal: true

module Resolvers
  module AppliesPolicyScope
    extend ActiveSupport::Concern

    def initialize(options = {})
      config = self.class.config

      base_scope = options[:scope] || (config[:scope] && instance_eval(&config[:scope]))

      options[:scope] = Pundit.policy_scope! options.dig(:context, :current_user), base_scope

      super(options)
    end
  end
end
