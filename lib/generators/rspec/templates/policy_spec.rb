<%-
  # vim: set ft=ruby.eruby :
-%>
# frozen_string_literal: true

RSpec.describe <%= class_name %>Policy, type: :policy do
  subject { described_class.new(identity, <%= factory_name %>) }

  let_it_be(<%= factory_name.inspect %>) { FactoryBot.create <%= factory_name.inspect %> }

  <%- if manager_restricted? -%>
  it_behaves_like "a manager-restricted model policy"
  <%- else -%>
  it_behaves_like "an internally-managed model policy"
  <%- end -%>
end
