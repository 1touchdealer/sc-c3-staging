class Category < ActiveRecord::Base
  has_ancestry
  has_many :needs
  has_many :resources

  default_scope { where(:active => true).order('name ASC') }
end
