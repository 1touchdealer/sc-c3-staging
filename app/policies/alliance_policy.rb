class AlliancePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        scope
      elsif user.alliance_admin?
        scope.where id: user.alliance_id
      end
    end
  end

  def index?
    super || user.alliance_admin?
  end

  def update?
    super || user.alliance_admin?
  end
end
