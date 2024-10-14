# frozen_string_literal: true

module Templates
  module Slots
    class Renderer < Support::HookBased::Actor
      include Dry::Initializer[undefined: false].define -> do
        param :raw_template, Types::String

        option :assigns, Types::Assigns, default: proc { {} }

        option :error_mode, Types::ErrorMode, default: proc { :strict }

        option :force, Types::Bool, default: proc { false }

        option :kind, Types::SlotKind, default: proc { "block" }
      end

      standard_execution!

      # @return [String]
      attr_reader :content

      # @return [<String>, nil]
      attr_reader :errors

      # @return [Templates::Slots::Instances::Abstract]
      attr_reader :slot

      # @return [Class(Templates::Slots::Instances::Abstract)]
      attr_reader :slot_klass

      # @return [Liquid::Template]
      attr_reader :template

      # @return [Boolean]
      attr_reader :valid

      alias valid? valid

      def call
        run_callbacks :execute do
          yield prepare!

          yield compile_template!

          yield render!

          yield build_slot!
        end

        Success slot
      end

      wrapped_hook! def prepare
        @slot_klass = Templates::Slots::Instances::Abstract.klass_for(kind)

        @content = @errors = @valid = nil

        super
      end

      wrapped_hook! def compile_template
        compilation_options = { error_mode:, force:, kind:, }

        @template = yield call_operation("templates.slots.compile", raw_template, **compilation_options)

        super
      end

      wrapped_hook! def render
        rendered = template.render(assigns, strict_filters: true, strict_variables: true)

        @errors = template.errors.map(&:detailed_message)

        @valid = errors.blank?

        binding.pry unless valid?

        @content = yield call_operation("templates.slots.sanitize", rendered, kind:) if valid?

        super
      end

      wrapped_hook! def build_slot
        @slot = slot_klass.new(content:, errors:, valid:)

        super
      end
    end
  end
end
