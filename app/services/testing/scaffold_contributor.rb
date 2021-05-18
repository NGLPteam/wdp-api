# frozen_string_literal: true

module Testing
  class ScaffoldContributor
    extend Dry::Initializer

    include InitializerOptions

    option :kind, AppTypes::ContributorKind, default: proc { :organization }

    def call
      contributor = FactoryBot.create :contributor, kind

      return contributor
    end
  end
end
