# frozen_string_literal: true

module Templates
  class Render < Support::SimpleServiceOperation
    service_klass Templates::Renderer
  end
end
