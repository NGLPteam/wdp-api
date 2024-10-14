# frozen_string_literal: true

module Templates
  module Slots
    class Compiler < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :raw_template, Types::String

        option :error_mode, Types::ErrorMode, default: proc { :strict }

        option :force, Types::Bool, default: proc { false }

        option :kind, Types::SlotKind, default: proc { "block" }
      end

      standard_execution!

      CACHE_KEY_FORMAT = "liquid/template/%<kind>s/%<error_mode>s/%<digest>s"

      # @return [String]
      attr_reader :cache_key

      # @return [String]
      attr_reader :digest

      # @return [String]
      attr_reader :content

      # @return [Liquid::Template]
      attr_reader :template

      # @return [Dry::Monads::Success(Liquid::Template)]
      def call
        run_callbacks :execute do
          yield prepare!

          yield compile!
        end

        Success template
      end

      wrapped_hook! def prepare
        @digest = Digest::SHA512.hexdigest(raw_template)

        @cache_key = CACHE_KEY_FORMAT % { kind:, error_mode:, digest:, }

        super
      end

      wrapped_hook! def compile
        # @environment = yield MeruAPI::Container["templates.environments.slot"].(kind:)

        @template = Rails.cache.fetch(cache_key, force:, expires_in: 1.day) do
          Liquid::Template.parse(raw_template, error_mode:)
        end

        super
      end
    end
  end
end
