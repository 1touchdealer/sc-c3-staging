class UserAreaOfInterest < ActiveRecord::Base
  belongs_to :user
  belongs_to :area_of_interest
end
