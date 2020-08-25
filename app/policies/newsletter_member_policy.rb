class NewsLetterMemberPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.super_admin? || user.state_director?
        return scope
      end

      clauses = ["id = #{user.id}"]
      if user.alliance_admin? && user.alliance_id
        clauses << "alliance_id = #{user.alliance_id}"
      elsif user.business_admin?
        clauses << "business_id = #{user.business_id}"
      elsif user.church_admin?
        clauses << "church_id = #{user.church_id}"
      end
      scope.where clauses.join(' OR ')
    end
  end

  def index?
    super || user.alliance_admin? || user.business_admin? || user.church_admin?
  end

  def create?
    super || user.alliance_admin? || user.business_admin? || user.church_admin?
  end

  def update?
    super || user.alliance_admin? || user.business_admin? || user.church_admin? || user.id == record.id
  end

  def destroy?
    super || user.alliance_admin? || user.business_admin? || user.church_admin?
  end
end
