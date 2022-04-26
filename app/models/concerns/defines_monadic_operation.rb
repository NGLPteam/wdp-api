# frozen_string_literal: true

module DefinesMonadicOperation
  # @return [void]
  def monadic_operation!(method_name)
    class_eval <<~RUBY, __FILE__, __LINE__ + 1
      def #{method_name}!(...)
        #{method_name}(...).value!.then do |result|
          Dry::Monads::Unit == result ? nil : result
        end
      end
    RUBY
  end
end
