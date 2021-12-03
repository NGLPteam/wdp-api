# frozen_string_literal: true

module TestHelpers
  module GraphQLRequest
    module ExampleHelpers
      def make_default_request!(variables: graphql_variables, token: self.token, **options)
        make_graphql_request! query, token: token, variables: variables, **options
      end

      def make_graphql_request!(query, token: nil, variables: {}, camelize_variables: true, no_top_level_errors: true)
        headers = {}

        headers["ACCEPT"] = "application/json"
        headers["AUTHORIZATION"] = "Bearer #{token}" if token.present?
        headers["CONTENT_TYPE"] = "application/json"

        params = {
          query: query&.strip_heredoc&.strip
        }

        params[:variables] = encode_graphql_variables variables, camelize: camelize_variables

        params.compact!

        post "/graphql", params: params.to_json, headers: headers

        expect(Array(graphql_response(:errors))).to eq([]) if no_top_level_errors
      end

      def expect_graphql_response_data(shape, **options)
        expect(graphql_response(**options)).to include_json data: shape
      end

      def graphql_response(*path, decamelize: false)
        parsed_graphql_response(decamelize: decamelize).then do |res|
          path.present? ? res.dig(*path) : res
        end
      end

      def parsed_graphql_response(decamelize: false)
        WDPAPI::TestContainer["requests.response_transformer"].call(response.parsed_body, decamelize: decamelize)
      end

      def encode_graphql_variables(variables, camelize: true)
        return nil if variables.blank?

        return variables unless camelize

        WDPAPI::TestContainer["requests.variable_transformer"].call(variables)
      end

      def generate_slug_for(uuid)
        WDPAPI::Container["slugs.encode_id"].call(uuid).value_or(nil)
      end

      def random_slug
        generate_slug_for SecureRandom.uuid
      end

      def have_typename(name)
        include_json __typename: name
      end

      def graphql_upload_from(*path_parts, **options)
        uploaded_file = Rails.root.join(*path_parts).open "r+" do |f|
          f.binmode

          Shrine.upload(f, :cache)
        end

        to_graphql_upload uploaded_file, **options
      end

      # @param [Shrine::UploadedFile] uploaded_file
      # @return [Hash]
      def to_graphql_upload(uploaded_file, storage: "CACHE")
        uploaded_file.as_json.merge(storage: storage).deep_transform_keys do |k|
          k.to_s.camelize(:lower)
        end.tap do |h|
          h["metadata"].delete "size"
        end
      end

      def gql
        @gql ||= GQLShaper.new
      end
    end

    class GQLShaper
      def attribute_errors
        AttributeErrorsBuilder.new.tap do |eb|
          yield eb if block_given?
        end.to_errors
      end

      def attribute_error_on(...)
        AttributeErrorBuilder.build(...)
      end
    end

    class AttributeErrorsBuilder
      def initialize
        @errors = []
      end

      def error(...)
        @errors << AttributeErrorBuilder.build(...)

        return self
      end

      def to_errors
        @errors
      end
    end

    class AttributeErrorBuilder
      include Dry::Initializer.define -> do
        param :path, Dry::Types["string"]
      end

      def included_in(*items)
        list = items.flatten.join(", ")

        messages << I18n.t("dry_validation.errors.included_in?.arg.default", list: list)
      end

      def exact(message)
        messages << message

        return self
      end

      def message(key, **options)
        case key
        when Symbol, /\A\S+\z/
          messages << I18n.t(key, **options, scope: %i[dry_validation errors])
        when Regexp
          messages << key
        end

        return self
      end

      alias msg message

      def to_error
        {
          path: path,
          messages: messages,
        }
      end

      private

      def messages
        @messages ||= []
      end

      class << self
        def build(path, key = nil, **options)
          AttributeErrorBuilder.new(path).tap do |eb|
            eb.message key, **options if key.present?

            yield eb if block_given?
          end.to_error
        end
      end
    end
  end
end

RSpec.shared_context "with default graphql context" do
  let(:query) { "" }

  let(:token) { nil }

  let(:graphql_variables) { {} }
end

RSpec.configure do |config|
  config.include TestHelpers::GraphQLRequest::ExampleHelpers, type: :request
  config.include_context "with default graphql context", type: :request
end
