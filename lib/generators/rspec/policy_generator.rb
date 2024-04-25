# frozen_string_literal: true

module Rspec
  module Generators
    class PolicyGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      class_option :manager_restricted, type: :boolean, default: false

      def create_policy_spec
        template "policy_spec.rb", File.join("spec/policies", class_path, "#{file_name}_policy_spec.rb")
      end

      private

      def factory_name
        singular_name.to_sym
      end

      def manager_restricted?
        options[:manager_restricted]
      end
    end
  end
end
