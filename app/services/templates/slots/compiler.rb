# frozen_string_literal: true

module Templates
  module Slots
    class Compiler < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :raw_template, Types::String

        option :kind, Types::SlotKind, default: proc { "block" }
      end

      standard_execution!

      CACHE_KEY_FORMAT = "liquid/template/%<kind>s/%<digest>s"

      # @return [String]
      attr_reader :cache_key

      # @return [String]
      attr_reader :content

      # @return [String]
      attr_reader :digest

      # @see Templates::Slots::BuildEnvironment
      # @see Templates::Slots::EnvironmentBuilder
      # @return [Liquid::Environment]
      attr_reader :environment

      # @return [Liquid::Template]
      attr_reader :template

      # @return [{ Symbol => Object }]
      attr_reader :template_options

      # @return [Dry::Monads::Success(Liquid::Template)]
      # @return [Dry::Monads::Failure(:syntax_error, Liquid::SyntaxError)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield compile!
        end

        Success template
      end

      wrapped_hook! def prepare
        @digest = Digest::SHA512.hexdigest(raw_template)

        @cache_key = CACHE_KEY_FORMAT % { kind:, digest:, }

        @environment = yield call_operation("templates.slots.build_environment", kind:)

        super
      end

      wrapped_hook! def compile
        @template = Liquid::Template.parse(
          raw_template,
          environment:,
          line_numbers: true
        )

        super
      rescue Liquid::SyntaxError => e
        Failure[:syntax_error, e]
      end
    end
  end
end
