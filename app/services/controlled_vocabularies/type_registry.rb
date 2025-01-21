# frozen_string_literal: true

module ControlledVocabularies
  # The shared type registry used by {ControlledVocabularies::Contracts::Base}.
  TypeRegistry = Support::Schemas::TypeContainer.new.configure do |tc|
    tc.add! :description, Types::Description
    tc.add! :identifier, Types::Identifier
    tc.add! :label, Types::Label
    tc.add! :namespace, Types::Namespace
    tc.add! :name, Types::Name
    tc.add! :priority, Types::Priority
    tc.add! :provides, Types::Provides
    tc.add! :tags, Types::Tags
    tc.add! :url, Types::URL
    tc.add! :version, Types::Version
  end
end
