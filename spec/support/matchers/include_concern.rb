# frozen_string_literal: true

RSpec::Matchers.define :include_concern do |model_concern|
  match do |actual|
    raise "Expected model class: #{actual.inspect}" unless Support::Types::ModelClass[actual]
    raise "expected concern" unless Support::Types.Instance(ActiveSupport::Concern)[expected]

    @actual = actual.model_name.to_s

    @expected = model_concern.name

    actual < expected
  end
end
