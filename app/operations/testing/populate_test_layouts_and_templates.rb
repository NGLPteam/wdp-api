# frozen_string_literal: true

module Testing
  class PopulateTestLayoutsAndTemplates
    include Dry::Monads[:result, :do]

    include MonadicPersistence

    def call
      SchemaVersion.find_each(&:populate_root_layouts!)

      Community.find_each(&:invalidate_layouts!)
      Collection.find_each(&:invalidate_layouts!)
      Item.find_each(&:invalidate_layouts!)

      Rendering::ProcessLayoutInvalidationsJob.perform_later

      Success()
    end
  end
end
