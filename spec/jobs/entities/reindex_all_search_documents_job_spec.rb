# frozen_string_literal: true

RSpec.describe Entities::ReindexAllSearchDocumentsJob, type: :job do
  it_behaves_like "a void operation job", "entities.index_search_documents"
end
