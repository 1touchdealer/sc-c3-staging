class CampaignPolicy < ApplicationPolicy
  def create?
    user.present?
  end
end
