# frozen_string_literal: true

module Contributors
  # @deprecated Use {Contributions::Attach} instead.
  class AttachItem < Support::SimpleServiceOperation
    service_klass Contributions::Attacher
  end
end
