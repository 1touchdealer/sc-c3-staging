class Resource < ActiveRecord::Base
  include AASM

  belongs_to :category
  belongs_to :need
  belongs_to :user
  # belongs_to :resourceful, polymorphic: true
  # has_one :location, as: :locationable, dependent: :destroy


  has_many :matches, :as => :first_matchable, dependent: :destroy #first_matchable is resource
  has_one :campaign, through: :need
  # has_many :requests

  has_attached_file :image, styles: { medium: "300x300>" }, s3_protocol: :https

  # attr_accessor :terms_conditions_checkbox

  # accepts_nested_attributes_for :location
  #
  # accepts_nested_attributes_for :category

  # after_create do
  #   check_matches
  # end

  before_save :destroy_image

  # validates :title, :resourceful, :description, :category, presence: true
  validates :value, presence: true, on: :create
  # validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates_attachment_content_type :image, content_type: /image/
  # validates_acceptance_of :terms_conditions_checkbox

  #--Validation for quantity level to be greater than the quantity claimed
  # validate :validate_floor_quantity_input, on: :update

  # def validate_floor_quantity_input
  #   if quantity < quantity_claimed
  #     errors.add(:quantity, "Quantity cannot be updated to a value less than the quantity already claimed.")
  #   end
  # end

  # after_update :test_quantity_to_close_resource
  # def test_quantity_to_close_resource
  #   if quantity <= quantity_claimed
  #     close if may_close?
  #   end
  # end

  # scope :recent, -> { order("created_at desc").limit(25) }

  # def to_param
  #   sluggify("#{id}-#{title}")
  # end

  # def sluggify str
  #   slug = str.downcase.gsub(/[^0-9a-z_ -]/i, '')
  #   slug = slug.gsub(/\s+/, '-').squeeze('-')
  #   slug
  # end

  # def user
  #   resourceful && resourceful.is_a?(User) ? resourceful : nil
  # end

  # def user=(user)
  #   self.resourceful = user
  # end

  # because of conflicts with the ruby core module method open
  # use need.fire_events(:open)
  aasm :workflow_state do
    state :open, initial: true
    # state :reserved
    state :accepted
    state :denied
    state :removed

    event :accept do
      transitions from: :open, to: :accepted
      after do
        need.meet! if !need.met?
      end
    end
  end

  # def button_text
  #   "request this resource "
  # end

  # def s3_url(style = nil, expires_in = 30.minutes)
  #   image.s3_object(style).url_for(:read, :secure => true, :expires => expires_in).to_s
  # end

  def delete_image=(value)
    @delete_image = value
  end

  def delete_image
    @delete_image ||= "0"
  end

  # def check_matches(exclude_ids=[])
  #   if self.location
  #     needs = Need.where('user_id != ? AND category_id = ? AND workflow_state = ?', self.resourceful_id, self.category_id, 'open')
  #     needs = needs.where('id NOT IN (?)', exclude_ids.blank? ? '' : exclude_ids)
  #     needs.each do |need|
  #       if location.within_range?(need.location, 25)
  #         Match.create(category: Category.find(self.category_id), first_matchable: self, second_matchable: need)
  #       end
  #     end
  #   end
  # end

  # def self.build_from(need, resource_hash, user)
  #   resource_category = resource_hash[:category_id] ? Category.find(resource_hash[:category_id]) : need.try(:category)
  #   resource_title = resource_hash[:title] || need.try(:title)
  #   user_location = user.location
  #   #need.location.skip_address_validation = true
  #   if user_location
  #     resource_location = user_location.dup
  #     #resource_location.is_main = false
  #     #resource_location.skip_address_validation = true
  #   else
  #     resource_location = need.try(:location).try(:dup)
  #     #if resource_location
  #     #  resource_location.skip_address_validation = true
  #     #end
  #   end
  #   Resource.new(workflow_state: 'reserved', title: resource_title, description: resource_hash[:description], value: resource_hash[:value], category: resource_category, resourceful: user, location: resource_location)
  # end

  # def increment_quantity_claimed
  #   self.quantity_claimed += 1
  # end

  # def quantity_remaining
  #   return self.quantity - self.quantity_claimed
  # end

  private
  def destroy_image
    self.image.clear if @delete_image == "1"
  end

  # def cancel_matches
  #   matches.each do |match|
  #     match.cancel if match.open?
  #   end
  # end
end
