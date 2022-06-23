# frozen_string_literal: true

RSpec.describe Entities::AuditHierarchiesJob, type: :job do
  it_behaves_like "a void operation job", "entities.audit_hierarchies"
end
