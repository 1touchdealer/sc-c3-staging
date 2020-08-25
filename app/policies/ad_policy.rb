class AdPolicy < ApplicationPolicy
  def create?
    super || user.business_admin?
  end

  def update?
    super || user.business_admin?
  end
end
