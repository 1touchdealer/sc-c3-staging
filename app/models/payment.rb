class Payment < ActiveRecord::Base
  belongs_to :user

  after_create :update_user_expiration

  private
  def update_user_expiration
    expiration = [user.expiration, Time.now].compact.max + 1.year
    user.update_attribute :expiration, expiration
  end
end
