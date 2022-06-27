# frozen_string_literal: true

RSpec.describe Entities::SynchronizeJob, type: :job do
  let_it_be(:entity) { FactoryBot.create :collection }

  it_behaves_like "a pass-through operation job", "entities.sync" do
    let!(:job_arg) do
      entity
    end
  end
end
