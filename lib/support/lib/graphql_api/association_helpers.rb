# frozen_string_literal: true

module Support
  module GraphQLAPI
    # Helper methods for ensuring associations are loaded.
    module AssociationHelpers
      extend ActiveSupport::Concern

      def association_loader_for(association, klass: object&.class, record: object)
        if !record.kind_of?(ActiveRecord::Base)
          # Handle AnonymousUser, other proxies
          Promise.resolve(record.try(association))
        elsif record.association(association).loaded?
          Promise.resolve(record.public_send(association))
        else
          Support::Loaders::AssociationLoader.for(klass, association).load(record)
        end
      end

      module ClassMethods
        # @param [Symbol] association_name
        # @param [Symbol] as
        # @return [void]
        def load_association!(association_name, as: association_name)
          class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def #{as}                                                     # def foo
            association_loader_for(#{association_name.to_sym.inspect})  #   association_loader_for(:foo)
          end                                                           # end
          RUBY
        end

        # @param [Symbol] from
        # @return [void]
        def load_current_state!(from: :transitions)
          class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def current_state
            #{from}.then do
              object.current_state
            end
          end
          RUBY
        end
      end
    end
  end
end
