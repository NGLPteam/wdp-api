# frozen_string_literal: true

module Filtering
  TypeContainer = Support::DryGQL::TypeContainer.new.configure do |tc|
    tc.add! :date_match, Filtering::Inputs::DateMatch

    tc.add! :float_match, Filtering::Inputs::FloatMatch

    tc.add! :integer_match, Filtering::Inputs::IntegerMatch

    tc.add! :time_match, Filtering::Inputs::TimeMatch

    tc.add_enum! ::Types::HarvestMessageLevelType
  end
end
