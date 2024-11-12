# frozen_string_literal: true

RSpec.describe Templates::Slots::Render, type: :operation, template_slot_rendering: true do
  attr_reader :render_result
  attr_reader :slot

  def rendering_the_template
    @render_result = operation.(raw_template, assigns:, force:, kind:)
  ensure
    @slot = @render_result.value_or(nil)
  end

  context "with a valid block template" do
    block!

    let_assign!(:name) { "Test" }

    raw_template! <<~LIQUID
    <p invalid-attribute="foo">Hello, {{ name }}!</p>
    LIQUID

    it "renders okay" do
      expect(rendering_the_template).to succeed

      expect(slot.content).to include "<p>Hello, Test!</p>"
    end
  end

  context "with a valid inline template" do
    inline!

    let_assign!(:name) { "Test" }

    raw_template! <<~LIQUID
    Hello, {{ name }}!
    LIQUID

    it "renders okay" do
      expect(rendering_the_template).to succeed

      expect(slot.content).to include "Hello, Test!"
      expect(slot).to be_compiled
      expect(slot).to be_rendered
      expect(slot.liquid_errors).to be_blank
    end
  end

  context "with a syntax error" do
    raw_template! <<~LIQUID
    Hello, {{
    LIQUID

    it "renders with errors" do
      expect(rendering_the_template).to succeed

      expect(slot.content).to be_blank
      expect(slot).not_to be_compiled
      expect(slot).not_to be_rendered
      expect(slot.liquid_errors).to contain_exactly(be_syntax_error)
    end
  end

  context "with a render-time error" do
    raw_template! <<~LIQUID
    {% include 'template/does/not/exist' %}
    LIQUID

    it "renders with errors" do
      expect(rendering_the_template).to succeed

      expect(slot.content).to be_blank
      expect(slot).to be_compiled
      expect(slot).not_to be_rendered
      expect(slot.liquid_errors).to contain_exactly(be_file_system_error)
    end
  end
end
