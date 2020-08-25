class NeedPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        scope
      elsif user.alliance_admin?
        scope.where organization_id: user.alliance_id, organization_type: Alliance
      elsif user.business_admin?
        scope.where organization_id: user.business_id, organization_type: Business
      elsif user.church_admin?
        scope.where organization_id: user.church_id, organization_type: Church
      else
        scope.where user_id: user.id
      end
    end
  end
end
