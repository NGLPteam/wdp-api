# frozen_string_literal: true

# Iteration jobs should limit themselves to 5 minutes by default.
JobIteration.max_job_runtime = 5.minutes
