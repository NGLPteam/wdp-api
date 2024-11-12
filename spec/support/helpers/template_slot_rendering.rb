# frozen_string_literal: true

require_relative "hash_setter"

module TestHelpers
  TemplateSlotAssignsHelpers = TestHelpers::HashSetter.new(:assigns)

  module TemplateSlotSpecHelpers
    def block!
      let(:kind) { "block" }
    end

    def inline!
      let(:kind) { "inline" }
    end

    def raw_template!(template)
      template = template.to_s.strip_heredoc.strip

      let!(:raw_template) { template }
    end
  end
end

RSpec.shared_context "template slot rendering" do
  let(:force) { true }
  let(:kind) { "block" }
  let(:raw_template) { "" }
end

RSpec.configure do |config|
  config.include TestHelpers::TemplateSlotAssignsHelpers, template_slot_rendering: true
  config.extend TestHelpers::TemplateSlotSpecHelpers, template_slot_rendering: true

  config.include_context "template slot rendering", template_slot_rendering: true
end
