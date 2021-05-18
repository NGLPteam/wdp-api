# frozen_string_literal: true

module Testing
  class ScaffoldContributors
    extend Dry::Initializer

    include InitializerOptions

    option :destroy_existing, AppTypes::Bool, default: proc { true }
    option :organization_count, AppTypes::Integer, default: proc { 20 }
    option :people_count, AppTypes::Integer, default: proc { 20 }

    def call
      Contributor.destroy_all if destroy_existing

      orgs = Testing::ScaffoldContributor.new kind: :organization

      organization_count.times { orgs.call }

      people = Testing::ScaffoldContributor.new kind: :person

      people_count.times { people.call }
    end
  end
end
