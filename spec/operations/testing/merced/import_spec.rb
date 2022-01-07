# frozen_string_literal: true

RSpec.describe Testing::Merced::Import, type: :operation do
  around do |example|
    Rails.root.join("spec", "data", "lorempixel.jpg").open("r+") do |f|
      stub_request(:get, /escholarship/).
        to_return(body: f, status: 200)

      example.run
    end
  end

  xit "creates the expected hierarchy" do
    expected = Testing::Merced::ParseUnitHierarchy.new.call.value!

    hierarchy_count = expected[:hierarchy_count]

    expect do
      operation.call
    end.to change(Community, :count).by(1).and change(Collection, :count).by(hierarchy_count)
  end
end
