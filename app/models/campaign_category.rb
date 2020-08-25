class CampaignCategory < ActiveRecord::Base
  has_many :campaigns
end
