# frozen_string_literal: true

module Support
  module HookBased
    # @api private
    class WrappedHook < AbstractHookModule
      def initialize(...)
        super

        @wrapper = Support::HookBased::WrappedHook::Wrapper.new(hook_name)
        @watcher = Support::HookBased::WrappedHook::Watcher.new(hook_name)

        define_base_hook!
        define_wrapper!
      end

      def included(base)
        super

        base.include Dry::Monads::Do.for(hook_name)
        base.define_model_callbacks hook_name
        base.extend @watcher
        base.prepend @wrapper

        base.__send__ :"around_#{hook_name}", :benchmark_hook!, if: :benchmark_hooks?
      end

      private

      # @return [void]
      def define_base_hook!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{hook_name}
          Dry::Monads.Success()
        end
        RUBY
      end

      # @return [void]
      def define_wrapper!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{hook_name}!
          @current_hook = #{hook_name.inspect}

          run_callbacks #{hook_name.inspect} do
            enforce_monadic do
              #{hook_name}
            end
          end
        ensure
          @current_hook = nil
        end
        RUBY
      end

      # @api private
      class Watcher < AbstractHookModule
        def initialize(...)
          super

          class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def inherited(subclass)
            super

            subclass.include Dry::Monads::Do.for(#{hook_name.inspect})
          end
          RUBY
        end
      end

      # @api private
      class Wrapper < AbstractHookModule
        def prepended(base)
          super

          Dry::Monads::Do.wrap_method(self, hook_name, :public)
        end
      end
    end
  end
end
