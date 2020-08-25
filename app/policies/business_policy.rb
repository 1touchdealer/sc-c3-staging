class BusinessPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        scope
      elsif user.business_admin?
        scope.where id: user.business_id
      end
    end
  end

  def index?
    super || user.business_admin?
  end

  def update?
    super || user.business_admin?
  end
end
