class AddSocialMediaLinksToAbCs < ActiveRecord::Migration
  def change
      add_column :churches, :website_url, :text
      add_column :churches, :facebook_url, :text
      add_column :churches, :twitter_url, :text
      add_column :churches, :gplus_url, :text

      add_column :businesses, :website_url, :text
      add_column :businesses, :facebook_url, :text
      add_column :businesses, :twitter_url, :text
      add_column :businesses, :gplus_url, :text

      add_column :alliances, :website_url, :text
      add_column :alliances, :facebook_url, :text
      add_column :alliances, :twitter_url, :text
      add_column :alliances, :gplus_url, :text
  end
end
