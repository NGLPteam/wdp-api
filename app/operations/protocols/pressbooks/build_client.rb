# frozen_string_literal: true

module Protocols
  module Pressbooks
    # @see Protocols::Pressbooks::ClientBuilder
    class BuildClient < Support::SimpleServiceOperation
      service_klass Protocols::Pressbooks::ClientBuilder
    end
  end
end
