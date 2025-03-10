# frozen_string_literal: true

RSpec::Matchers.define_negated_matcher :keep_the_same, :change
RSpec::Matchers.define_negated_matcher :execute_safely, :raise_error
RSpec::Matchers.define_negated_matcher :exclude, :include
RSpec::Matchers.define_negated_matcher :have_enqueued_no_jobs, :have_enqueued_job
