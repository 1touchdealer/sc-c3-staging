class ExpiredCardPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin?
        scope
      end
    end
  end

  def index?
    user.super_admin?
  end
end
