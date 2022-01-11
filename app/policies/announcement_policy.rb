# frozen_string_literal: true

# Most permissions for an {Announcement} derive from the parent entity's
# `update` permission.
#
# @see Announcement
class AnnouncementPolicy < EntityChildRecordPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
