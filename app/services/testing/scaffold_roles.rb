# frozen_string_literal: true

module Testing
  class ScaffoldRoles
    extend Dry::Initializer

    prepend HushActiveRecord

    def call
      make_role! "Manager", all: { read: true, create: true, update: true, delete: true }
      make_role! "Editor", self: { read: true, update: true }, items: { read: true, update: true }
      make_role! "Reader", all: { read: true }
    end

    private

    def make_role!(name, all: {}, **control_list)
      role = Role.where(name: name).first_or_initialize

      role.access_control_list = control_list.reverse_merge(self: all, collections: all, items: all)

      role.save!
    end
  end
end
