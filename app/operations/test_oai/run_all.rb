# frozen_string_literal: true

module TestOAI
  class RunAll
    include Dry::Monads[:do, :result]
    include WDPAPI::Deps[
      cornell: "test_oai.flows.cornell",
    ]

    def call
      yield cornell.call

      Success nil
    end
  end
end
