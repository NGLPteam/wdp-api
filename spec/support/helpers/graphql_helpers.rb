# frozen_string_literal: true

module TestHelpers
  module GraphQLRequest
    module ExampleHelpers
      def expect_request!(**options, &block)
        tester = RequestTesterBuilder.new(&block).call

        options[:no_top_level_errors] = !tester.has_top_level_errors?

        req_expectation = tester.has_expectation? ? tester.expectation : execute_safely

        expect_the_default_request(**options).to req_expectation

        if tester.has_data? || tester.has_top_level_errors?
          aggregate_failures do
            expect_graphql_data tester.data if tester.has_data?

            expect_graphql_response_errors tester.top_level_errors if tester.has_top_level_errors?
          end
        end
      end

      def expect_the_default_request(run_jobs: false, **options)
        expect do
          make_default_request!(**options)

          flush_enqueued_jobs if run_jobs
        end
      end

      def make_default_request!(variables: graphql_variables, token: self.token, **options)
        make_graphql_request! query, token: token, variables: variables, **options
      end

      def make_graphql_request!(query, token: nil, variables: {}, camelize_variables: true, no_top_level_errors: true, operation: operation_name)
        headers = {}

        headers["ACCEPT"] = "application/json"
        headers["AUTHORIZATION"] = "Bearer #{token}" if token.present?
        headers["CONTENT_TYPE"] = "application/json"

        params = {
          query: query&.strip_heredoc&.strip
        }

        params[:operationName] = operation if operation.present?

        params[:variables] = encode_graphql_variables variables, camelize: camelize_variables

        params.compact!

        post "/graphql", params: params.to_json, headers: headers

        expect(Array(graphql_response(:errors))).to eq([]) if no_top_level_errors
      end

      def expect_graphql_data(shape)
        expect(graphql_response(decamelize: true)).to include_json data: shape
      end

      def expect_graphql_response_data(shape, **options)
        expect(graphql_response(**options)).to include_json data: shape
      end

      def expect_graphql_response_errors(shape)
        expect(graphql_response(decamelize: true)).to include_json errors: shape
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
      def to_graphql_upload(uploaded_file, storage: "CACHE", alt: nil)
        uploaded_file.as_json.merge(storage: storage).deep_transform_keys do |k|
          k.to_s.camelize(:lower)
        end.tap do |h|
          h["metadata"]["alt"] = alt if alt.present?
          h["metadata"].delete "size"
        end
      end

      def gql
        @gql ||= GQLShaper.new
      end
    end

    class GQLShaper
      def mutation(...)
        MutationShaper.build(...)
      end

      def empty_mutation(name)
        query do |q|
          q[name] = nil
        end
      end

      def named(...)
        NamedObjectShaper.build(...)
      end

      def object(...)
        ObjectShaper.build(...)
      end

      alias query object

      def top_level_unauthorized
        array do |a|
          a.item do |o|
            o.prop :extensions do |ext|
              ext[:code] = "FORBIDDEN"
            end

            o[:message] = I18n.t("server_messages.auth.forbidden")
          end
        end
      end

      def attribute_errors(...)
        AttributeErrorsBuilder.build(...)
      end

      def attribute_error_on(...)
        AttributeErrorBuilder.build(...)
      end
    end

    module BuildableObject
      extend ActiveSupport::Concern

      included do
        extend ActiveModel::Callbacks

        define_model_callbacks :build, :compile
      end

      UNSET = Object.new.freeze

      def initialize(*)
        super if defined?(super)
      end

      def build
        run_callbacks :build do
          yield self if block_given?
        end

        compiled = run_callbacks :compile do
          compile
        end

        return compiled
      end

      def []=(key, value)
        prop(key, value)
      end

      def prop(key, value = UNSET, &block)
        if value == UNSET
          if block_given?
            object_at(key, &block)
          else
            raise "must provide a value or a block"
          end
        elsif block_given?
          raise "cannot provide both a value and a block"
        else
          body[key] = value
        end

        return self
      end

      def object_at(key, &block)
        body[key] = ObjectShaper.build(&block)

        return self
      end

      def array(key, &block)
        body[key] = ObjectsShaper.build(&block)

        return self
      end

      def schema_properties(key: "schema_properties", prefix: nil, &block)
        body[key] = SchemaPropertiesShaper.build(path_prefix: prefix, &block)

        return self
      end

      def typename(value)
        body["__typename"] = value

        return self
      end

      def compile
        body.to_h
      end

      private

      # @api private
      def body
        @body ||= PropertyHash.new
      end

      module ClassMethods
        def build(*args, **kwargs, &block)
          new(*args, **kwargs).build(&block)
        end
      end
    end

    class ObjectShaper
      include BuildableObject
    end

    class ObjectsShaper
      def initialize(*)
        @items = []
      end

      def item(...)
        @items << build_item(...)

        return self
      end

      # @api private
      def build
        yield self if block_given?

        return compile
      end

      protected

      def build_item(...)
        ObjectShaper.build(...)
      end

      def compile
        return @items
      end

      class << self
        def build(*args, **kwargs, &block)
          new(*args, **kwargs).build(&block)
        end
      end
    end

    class NamedObjectShaper
      include BuildableObject
      extend Dry::Initializer

      param :name, Dry::Types["coercible.string"]

      def compile
        {
          name => body.to_h
        }.deep_symbolize_keys
      end
    end

    class MutationShaper < NamedObjectShaper
      option :schema, Dry::Types["bool"], default: proc { false }
      option :no_errors, Dry::Types["bool"], default: proc { true }
      option :no_global_errors, Dry::Types["bool"], default: proc { true }
      option :no_schema_errors, Dry::Types["bool"], default: proc { true }

      before_build :check_errors!

      def attribute_errors(...)
        body[:attribute_errors] = AttributeErrorsBuilder.build(...)

        return self
      end

      alias errors attribute_errors

      def global_errors(...)
        body[:global_errors] = GlobalErrorsBuilder.build(...)

        return self
      end

      def schema_errors(...)
        body[:schema_errors] = SchemaErrorsBuilder.build(...)

        return self
      end

      private

      def check_errors!
        body[:attribute_errors] = be_blank if no_errors
        body[:global_errors] = be_blank if no_global_errors
        body[:schema_errors] = be_blank if schema && no_schema_errors
      end

      def be_blank
        @be_blank ||= RSpec::Matchers::BuiltIn::BePredicate.new :be_blank
      end
    end

    class SchemaPropertiesShaper < ObjectsShaper
      UNSET = Object.new.freeze

      def initialize(path_prefix: nil)
        super()

        @path_prefix = path_prefix
      end

      def group(path, &block)
        item do |b|
          b.typename "GroupProperty"

          b[:path] = path.to_s

          b.schema_properties key: :properties, prefix: path.to_s do |sp|
            yield sp
          end
        end
      end

      Schemas::Properties::Scalar::Base.descendants.each do |klass|
        if klass.complex?
          define_method(klass.type_reference) do |path, value: UNSET, skip_value: false, &block|
            item do |b|
              b.typename klass.graphql_typename
              b[:path] = path.to_s
              b[:full_path] = normalize_full_path(path)

              return if skip_value

              set_method = :"set_#{klass.type_reference}!"

              if respond_to?(set_method, true)
                b[klass.graphql_value_key] = __send__(set_method, provided_value: value, &block)
              elsif block.present?
                b.prop(klass.graphql_value_key, &block)
              else
                b[klass.graphql_value_key] = value == UNSET ? nil : value
              end
            end
          end
        else
          define_method(klass.type_reference) do |path, value = UNSET|
            item do |b|
              b.typename klass.graphql_typename
              b[:path] = path.to_s
              b[:full_path] = normalize_full_path(path)

              b[klass.graphql_value_key] = value unless value == UNSET
            end
          end
        end
      end

      private

      def normalize_full_path(path)
        [@path_prefix, path].compact.join(?.)
      end

      def set_variable_date!(provided_value: UNSET, &block)
        ObjectShaper.build do |obj|
          obj[:value] = nil
          obj[:precision] = "NONE"

          if provided_value != UNSET
            parsed = ::VariablePrecisionDate.parse provided_value

            unless parsed.none?
              obj[:value] = parsed.value.as_json
              obj[:precision] = ::Types::DatePrecisionType.name_for_value parsed.precision
            end
          end

          yield obj if block_given?
        end
      end
    end

    class AttributeErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        AttributeErrorBuilder.build(...)
      end
    end

    CamelizedErrorPath = Dry::Types["string"].constructor do |value|
      case value
      when Symbol then value.to_s.camelize(:lower)
      else
        value
      end
    end

    class AttributeErrorBuilder
      include Dry::Initializer[undefined: false].define -> do
        param :path, CamelizedErrorPath
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

    class GlobalErrorBuilder
      include BuildableObject
      include Dry::Initializer[undefined: false].define -> do
        param :input, Dry::Types["any"]
        option :message_args, Dry::Types["hash"], default: proc { {} }
        option :type, Dry::Types["coercible.string"], default: proc { "$server" }
      end

      before_build :set_type!
      before_build :set_input!

      def message(key, **args)
        prop :message, parse_message(key, **args)
      end

      alias msg message

      private

      def parse_message(key, **options)
        case key
        when Symbol, /\A\S+\z/
          I18n.t(key, **options, scope: %i[dry_validation errors])
        when Regexp
          key
        end
      end

      def set_input!
        msg input, **message_args if input.present?
      end

      def set_type!
        prop :type, type
      end
    end

    class GlobalErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        GlobalErrorBuilder.build(...)
      end
    end

    class SchemaErrorsBuilder < ObjectsShaper
      alias error item

      def build_item(...)
        SchemaErrorBuilder.build(...)
      end
    end

    class SchemaErrorBuilder
      include BuildableObject
      include Dry::Initializer[undefined: false].define -> do
        param :path, Dry::Types["coercible.string"]
      end

      before_build :set_path!

      def included_in(*items)
        set_message! I18n.t("dry_validation.errors.included_in?.arg.default", list: list)

        return self
      end

      def exact(message)
        set_message! message
      end

      def message(key, **options)
        case key
        when Symbol, /\A\S+\z/
          set_message! I18n.t(key, **options, scope: %i[dry_validation errors])
        when Regexp, String
          exact key
        end
      end

      alias msg message

      private

      def set_path!
        prop :path, path
      end

      def set_message!(value)
        prop :message, value

        return self
      end

      class << self
        def build(path, key = nil, **options)
          new(path).build do |eb|
            eb.message key, **options if key.present?

            yield eb if block_given?
          end
        end
      end
    end

    class RequestTester < Dry::Struct
      attribute :effects, Dry::Types["array"].optional
      attribute :expectation, Dry::Types["any"].optional
      attribute :data, Dry::Types["any"].optional
      attribute :top_level_errors, Dry::Types["any"].optional

      def has_data?
        data.present?
      end

      def has_expectation?
        !expectation.nil?
      end

      def has_top_level_errors?
        top_level_errors.present?
      end
    end

    class RequestTesterBuilder
      def initialize
        @gql = GQLShaper.new

        @effects = []

        @data = nil
        @top_level_errors = nil

        yield self if block_given?
      end

      # @return [RequestTester]
      def call
        expectation = @effects.reduce(&:and) if @effects.any?

        attrs = {
          data: @data,
          expectation: expectation,
          effects: @effects.presence,
          top_level_errors: @top_level_errors,
        }

        RequestTester.new attrs
      end

      def effect!(matcher)
        @effects << matcher
      end

      def data!(value)
        @data = value
      end

      def top_level_errors!(value)
        @top_level_errors = value
      end

      alias errors! top_level_errors!

      def unauthorized!
        top_level_errors! @gql.top_level_unauthorized
      end
    end
  end
end

RSpec.shared_context "with default graphql context" do
  let(:query) { "" }

  let(:token) { nil }

  let(:graphql_variables) { {} }

  let(:operation_name) { nil }
end

RSpec.configure do |config|
  config.include TestHelpers::GraphQLRequest::ExampleHelpers, type: :request
  config.include_context "with default graphql context", type: :request
end
