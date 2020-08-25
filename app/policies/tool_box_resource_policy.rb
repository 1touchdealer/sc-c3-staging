class ToolBoxResourcePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin?
        scope
      end
    end
  end

  def update?
    super
  end
end
