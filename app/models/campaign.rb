include ActionView::Helpers::DateHelper

class Campaign < ActiveRecord::Base
  belongs_to :user
  belongs_to :region
  has_many :campaign_donations
  has_many :needs
  has_many :resources, through: :needs
  belongs_to :campaign_category

  scope :open, -> { where(workflow_state: :open) }
  scope :approved, -> { where(approved: :true) }

  has_attached_file :image, styles: { medium: "375x330>" },
                            s3_protocol: :https
  validates :name, :description, :campaign_category_id, :region_id, presence: true
  validates :goal_amount, presence: true

  validates_attachment_content_type :image, content_type: /image/

  accepts_nested_attributes_for :needs

  def s3_url(style = nil, expires_in = 30.minutes)
    image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  end

  def update_total_fund(amount)
    if goal_amount == total_amount
      self.workflow_state = "successful"
    else
      self.total_amount = (total_amount.nil? ? 0 : total_amount)  + (amount/100)
    end
  end

  def percent_complete
    100 * total_amount.to_f / goal_amount
  end

  def days_left
    [(expiration_date - Date.today).to_i, 0].max
  end

  def age_in_words
    distance_of_time_in_words(Time.now, self.created_at)
  end

  def get_image_url url,path
    domain = url.gsub(path,'')
    return domain.concat(image.url)    
  end

  def total_donations
    self.campaign_donations.count
  end
end
