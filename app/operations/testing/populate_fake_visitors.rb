# frozen_string_literal: true

module Testing
  # @api private
  # @see FakeVisitor
  class PopulateFakeVisitors
    include Dry::Monads[:result]

    include WDPAPI::Deps[
      random_ip_address: "testing.random_ip_address",
    ]

    def call(force: false)
      return Success() if FakeVisitor.exists? && !force

      sequencer = FakeVisitor.sequencer

      # The maximum amount of fake visitors to be generated on each
      # execution of this. The anonymous count is this value - however
      # many users were actually sampled (> 250 if there are not enough unique users)
      max_visitors = Testing::RandomIPAddressSet.size

      # We want a half and half mix of real and anonymous users
      max_users = max_visitors / 2

      ips = random_ip_address.call(max_visitors)

      user_ids = User.sample(max_users).ids

      anonymous = Array.new(max_visitors - user_ids.size)

      user_ids += anonymous

      attributes = user_ids.shuffle.zip(ips).map do |(user_id, ip)|
        {
          user_id: user_id,
          ip: ip,
          user_agent: Faker::Internet.user_agent,
          sequence: sequencer.next
        }
      end

      FakeVisitor.insert_all attributes

      Success()
    end
  end
end
