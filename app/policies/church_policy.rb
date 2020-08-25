class ChurchPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        scope
      elsif user.church_admin?
        scope.where id: user.church_id
      end
    end
  end

  def index?
    super || user.church_admin?
  end

  def update?
    super || user.church_admin?
  end
end
