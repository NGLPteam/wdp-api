# frozen_string_literal: true

module Templates
  module MDX
    # @see Templates::MDX::PDFViewerBuilder
    class BuildPDFViewer < Support::SimpleServiceOperation
      service_klass Templates::MDX::PDFViewerBuilder
    end
  end
end
