class Need < ActiveRecord::Base
  include AASM

  # belongs_to :user
  # belongs_to :organization, polymorphic: true
  # has_one :location, as: :locationable, dependent: :destroy
  # has_many :requests
  has_many :resources
  belongs_to :campaign
  # has_many :matches, as: :second_matchable, dependent: :destroy #second matchable is need
  #
  # attr_accessor :terms_conditions_checkbox
  #
  # accepts_nested_attributes_for :location
  #
  # scope :recent, -> { order("created_at desc").limit(25) }
  # scope :in_open_state, -> { where(workflow_state: 'open') }
  #
  # #Test further validating user instead of user_id
  # validates :title, :user, :description, :category, presence: true
  # validates_acceptance_of :terms_conditions_checkbox

  # after_create do
  #   check_matches
  # end

  # after_update do
  #   check_matches
  # end

  # def to_param
  #   sluggify("#{id}-#{title}")
  # end
  #
  # def sluggify str
  #   slug = str.downcase.gsub(/[^0-9a-z_ -]/i, '')
  #   slug = slug.gsub(/\s+/, '-').squeeze('-')
  #   slug
  # end

  # because of conflicts with the ruby core module method open
  # use need.fire_events(:open)
  aasm :workflow_state do
    state :open, initial: true
    # state :reserved
    state :met
    # state :closed, after_enter: :cancel_matches
    # state :removed, after_enter: :cancel_matches

    event :open do
      transitions from: :reserved, to: :open
    end

    # event :reserve do
    #   transitions from: :open, to: :reserved
    # end

    event :meet do
      transitions from: [:open], to: :met
    end
  end

  # def button_text
  #   "meet this need (request)"
  # end
  #
  # def check_matches(exclude_ids=[])
  #   resources = Resource.where('resourceful_id != ? AND category_id = ? AND workflow_state = ?', self.user_id, self.category_id, 'open')
  #   resources = resources.where('id NOT IN (?)', exclude_ids.blank? ? nil : exclude_ids)
  #
  #   resources.each do |resource|
  #     if resource.location and self.location.within_range?(resource.location, 25)
  #       Match.create(category: Category.find(self.category_id), first_matchable: resource, second_matchable: self)
  #     end
  #   end
  # end
  #
  # def self.build_from(resource, need_hash, user)
  #   need_category = need_hash[:category_id] ? Category.find(need_hash[:category_id]) : resource.try(:category)
  #   need_title = need_hash[:title] || resource.try(:title)
  #   need_organization = user.alliance || user.church || user.business
  #   user_location = user.location || need_organization.try(:locations).try(:first)
  #   if user_location
  #     need_location = user_location.dup
  #     # need_location.is_main = false
  #     # need_location.skip_address_validation = true
  #   else
  #     need_location = resource.try(:location).try(:dup)
  #     # need_location.skip_address_validation = true
  #   end
  #   Need.new(workflow_state: 'reserved', title: need_title, description: need_hash[:description], category: need_category, user: user, location: need_location, organization: need_organization)
  # end

  private
  # def cancel_matches
  #   need.matches.each do |match|
  #     match.cancel if match.open?
  #   end
  # end
end
