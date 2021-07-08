# frozen_string_literal: true

RSpec.shared_context "stubs lorempixel" do
  before do
    stub_request(:get, %r{\Ahttps://lorempixel.com/.+}).
      to_return(
        status: 200,
        body: Rails.root.join("spec/data/lorempixel.jpg"),
        headers: {
          "Content-Type" => "image/jpeg"
        }
      )
  end
end
