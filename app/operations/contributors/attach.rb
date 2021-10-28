# frozen_string_literal: true

module Contributors
  class Attach
    include Dry::Monads[:result, :do]
    include WDPAPI::Deps[
      attach_collection: "contributors.attach_collection",
      attach_item: "contributors.attach_item",
    ]

    def call(contributor, contributable)
      case contributable
      when Collection
        attach_collection.call(contributor, contributable)
      when Item
        attach_item.call(contributor, contributable)
      else
        # :nocov:
        Failure[:invalid_contributable, "#{contributable.inspect} is not contributable"]
        # :nocov:
      end
    end
  end
end
