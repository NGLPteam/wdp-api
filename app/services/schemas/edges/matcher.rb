# frozen_string_literal: true

module Schemas
  module Edges
    # If matched, this will yield {Schemas::Edges::Edge}.
    ValidCase = Dry::Matcher::Case.new do |result, _|
      if result.success? && result.value!.kind_of?(Schemas::Edges::Edge)
        result.value!
      else
        Dry::Matcher::Undefined
      end
    end

    private_constant :ValidCase

    # If matched, this will yield {Schemas::Edges::Invalid}.
    UnacceptableCase = Dry::Matcher::Case.new do |result|
      if result.failure? && result.failure.first == :unacceptable_edge
        result.failure.second
      else
        Dry::Matcher::Undefined
      end
    end

    private_constant :UnacceptableCase

    # If matched, this will yield {Schemas::Edges::Incomprehensible}.
    IncomprehensibleCase = Dry::Matcher::Case.new do |result|
      if result.failure? && result.failure.first == :incomprehensible
        result.failure.second
      else
        Dry::Matcher::Undefined
      end
    end

    private_constant :IncomprehensibleCase

    # A dry-matcher for handling the three potential results of validating an edge:
    #
    # 1. `valid`: {Schemas::Edges::ValidCase}
    # 2. `unacceptable`: {Schemas::Edges::UnacceptableCase}
    # 3. `incomprehensible`: {Schemas::Edges::IncomprehensibleCase}
    Matcher = Dry::Matcher.new(
      edge: ValidCase,
      unacceptable: UnacceptableCase,
      incomprehensible: IncomprehensibleCase
    )
  end
end
