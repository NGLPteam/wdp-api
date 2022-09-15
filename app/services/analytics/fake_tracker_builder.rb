# frozen_string_literal: true

module Analytics
  class FakeTrackerBuilder
    include Dry::Core::Memoizable
    include Dry::Initializer[undefined: false].define -> do
      option :ip, Analytics::Types::String, default: proc { WDPAPI::Container["testing.random_ip_address"].() }
      option :user, Users::Types::Current.optional, default: proc { AnonymousUser.new }
      option :user_agent, Analytics::Types::String, default: proc { Faker::Internet.user_agent }
    end

    # @return [Ahoy::Tracker]
    def call
      tracker = Ahoy::Tracker.new(
        controller: controller,
        request: request
      )

      return tracker
    end

    private

    memoize def controller
      Testing::MockController.new request
    end

    # @return [ActionDispatch::Request]
    memoize def request
      Testing::RequestMocker.new(ip: ip, user_agent: user_agent).build
    end
  end
end
