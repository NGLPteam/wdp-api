# frozen_string_literal: true

module Testing
  # @api private
  class MockController
    include Dry::Initializer[undefined: false].define -> do
      param :request, Support::GlobalTypes.Instance(ActionDispatch::Request)
    end
  end
end
