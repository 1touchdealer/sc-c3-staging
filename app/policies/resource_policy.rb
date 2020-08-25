class ResourcePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        scope
      elsif user.alliance_admin?
        scope.where resourceful_id: user.alliance_id, resourceful_type: 'Alliance'
      elsif user.business_admin?
        scope.where resourceful_id: user.business_id, resourceful_type: 'Business'
      elsif user.church_admin?
        scope.where resourceful_id: user.church_id, resourceful_type: 'Church'
      else
        scope.where resourceful_id: user.id, resourceful_type: 'User'
      end
    end
  end

  def accept?
    user.super_admin? || user.state_director? || record.need.campaign.user_id == user.id
  end
end
