ActiveAdmin.register CampaignCategory do
  menu parent: 'NonProfit Entities'

  permit_params :name, :active
end
