# frozen_string_literal: true

module Roles
  class CalculateSystemRoles
    def call
      mapper = Roles::Mapper.new

      roles = mapper.call do |m|
        m.role! :admin do |r|
          r.acl ?*

          r.gacl ?*
        end

        m.role! :manager do |r|
          # A manager can do anything under its assigned hierarchy
          r.acl ?* do |acl|
            # Except delete the thing it is assigned to.
            acl.deny! "self.delete"
          end

          r.gacl "admin.access", "contributors.*", "users.read", "roles.read"
        end

        m.role! :editor do |r|
          r.acl do |acl|
            # An editor can read anything under its assigned hierarchy
            acl.allow! "*.read", "*.assets.read"
            # An editor can update any assigned entity as well as its subcollections and items
            acl.allow! "self.update", "collections.update", "items.update"
            # An editor can update any asset
            acl.allow! "*.assets.update"
          end

          r.gacl "admin.access", "contributors.read", "contributors.create", "contributors.update" do |gacl|
            gacl.deny! "contributors.delete"
            gacl.allow! "roles.read"
          end
        end

        m.role! :reader do |r|
          r.acl "*.read", "*.assets.read"

          r.gacl "contributors.read", "roles.read"
        end
      end

      return roles
    end
  end
end
