class Ad < ActiveRecord::Base
  include AASM

  belongs_to :region
  belongs_to :user

  scope :active, -> { where 'approval_state = ? and expiration > ?', 'approved', Time.now }

  has_attached_file :image, styles: { medium: "200x100", thumb: "100x50" }, default_url: ":class/:attachment/default/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  after_save :delete_cache

  aasm :approval_state do
    state :new, initial: true
    state :approved
    state :denied

    event :approve do
      transitions from: [:new, :denied], to: :approved
    end

    event :deny do
      transitions from: [:new, :approved], to: :denied
    end
  end

  def paid?
    charge_id.present?
  end

  def expired?
    expiration && expiration < Time.now
  end

  def monthly_fee
    region_id.present? ? 17500 : 57500
  end

  def self.all_in_region(region)
    # Include nil since ads with nil region_id are shown for all regions
    where(region_id: [region, nil])
  end

  private
  def delete_cache
    if region_id
      Rails.cache.delete("ads/#{region_id}")
      Rails.cache.delete("ads/all")
    else
      Rails.cache.delete_matched(/^ads\//)
    end
  end
end
