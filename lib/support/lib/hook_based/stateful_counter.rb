# frozen_string_literal: true

module Support
  module HookBased
    class StatefulCounter < AbstractProvider
      option :initial_value, Types::Integer, default: proc { 0 }

      def build_effect!
        Dry::Effects::Handler.State(attribute)
      end

      def define_provider!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{provider_name}                  # def provide_foo!
          @#{attribute}, _ = with_#{attribute} #{attribute} || #{initial_value} do  #   with_foo foo || 0 do
            yield                                                                   #     yield
          end                                                                       #   end
        end                                                                         # end
        RUBY
      end
    end
  end
end
