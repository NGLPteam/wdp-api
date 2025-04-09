# frozen_string_literal: true

module Users
  # A normalized PORO for {UserAccessInfo} for storing the data
  # directly on the {User}.
  class AccessInfo < Support::FlexibleStruct
    attribute? :access_management, Users::Types::AccessManagement
    attribute? :can_manage_access_globally, Users::Types::Bool.default(false)
    attribute? :can_manage_access_contextually, Users::Types::Bool.default(false)

    def global?
      access_management == "global"
    end

    def forbidden?
      access_management == "forbidden"
    end

    class << self
      # @param [User, UserAccessInfo, nil] source
      # @return [Users::AccessInfo]
      def wrap(source)
        case source
        in ::User
          wrap(source.reload_access_info)
        in ::UserAccessInfo
          new(source.to_wrapped)
        else
          new
        end
      end
    end
  end
end
