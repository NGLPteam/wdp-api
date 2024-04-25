# frozen_string_literal: true

module Support
  module HookBased
    class SimpleReader < AbstractProvider
      def build_effect!
        Dry::Effects::Handler.Reader(attribute)
      end

      def define_provider!
        class_eval <<~RUBY, __FILE__, __LINE__ + 1
        def #{provider_name}                  # def provide_foo!
          with_#{attribute} #{attribute} do   #   with_foo foo do
            yield                             #     yield
          end                                 #   end
        end                                   # end
        RUBY
      end
    end
  end
end
