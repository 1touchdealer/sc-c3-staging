class AttendeePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        scope
      else
        scope.joins(:event).where event: {user_id: user.id}
      end
    end
  end
end
