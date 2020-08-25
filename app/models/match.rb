class Match < ActiveRecord::Base
  include AASM

  belongs_to :category
  belongs_to :first_matchable, polymorphic: true #first matchable is request
  belongs_to :second_matchable, polymorphic: true #second matchable is need

  #has_one :point_offer_group, as: :offerable
  #has_one :sponsorship
  #has_one :sponsorship_location, through: :sponsorship, source: :location

  accepts_nested_attributes_for :first_matchable, :second_matchable

  before_create :auto_accept_for_resource_owner

  scope :completed, -> { where(:workflow_state => 'accepted') }

  aasm :workflow_state do
    state :open, initial: true # represents match for both an available resource and required need
    state :accepted  # represents user accepted
    state :declined  # represents user decline
    state :cancelled # represents a different match for resource or need was accepted first

    event :accept do
      before do
        self.second_matchable_acceptance = true
        #--First increment the quantity_claimed field of the associated resource
        resource.increment_quantity_claimed()
        #--Then test that the quantity is less than quantity_claimed to determine if the resource needs to be closed
        resource.close if resource.can_close? && (resource.quantity <= resource.quantity_claimed)
        need.close     if need.can_close?
      end

      after do
        CreativeChatterMailer.send_match_made_email_resource(self).deliver
        CreativeChatterMailer.send_match_made_email_need(self).deliver
        send_social_media_messages
        ActiveSupport::Notifications.instrument('match_accepted', {match: self})
        find_a_sponsor
      end
      transitions from: :open, to: :accepted
    end

    event :decline do
      after do |match|
        if resource.try(:reserved?)
          resource.fire_events(:open)
          CreativeChatterMailer.send_match_declined_email_resource(resource).deliver
          resource.check_matches([need.try(:id)||''])
        end
        need.fire_events(:open) if need.try(:reserved?)
      end
      transitions from: :open, to: :declined
    end

    event :cancel do
      transitions from: :open, to: :cancelled
    end
  end

  def display_match(_matchable_object)
    if self.first_matchable_type == _matchable_object.class.to_s
      self.second_matchable
    else
      self.first_matchable
    end
  end

  def need
    second_matchable
  end

  def need=(_need)
    self.second_matchable = _need
  end

  def resource
    first_matchable
  end

  def resource=(_resource)
    self.first_matchable = _resource
  end

  def description
    need.title
  end

  #def point_offers
  #  point_offer_group.try(:point_offers) || []
  #end

  def auto_accept_for_resource_owner
    # first matchable is always the resource with current setup
    self.first_matchable_acceptance = true
  end

  def send_match_made_email
    CreativeChatterMailer.send_match_made_email(self).deliver
  end

  def send_social_media_messages
    resource_user = first_matchable.resourceful
    need_user     = second_matchable.user
    SocialMedia.new('match', resource_user, self).post
    SocialMedia.new('match', need_user, self).post
  end

  #def find_a_sponsor
  #  sponsor_location = SponsorshipQueueItem.consume_next
  #  return nil unless sponsor_location

  #  if sponsorship
  #    self.sponsorship.sponsor_location = sponsor_location
  #  else
  #    self.sponsorship = Sponsorship.new(sponsor_location: sponsor_location)
  #  end
  #  sponsorship.save
  #  sponsor_location
  #end

  #need and resource params are hash representations
  def self.build_from(user, need_hash, resource_hash)
    return nil unless user and need_hash and resource_hash

    Match.transaction do

      match = Match.new

      resource = match.resource = Resource.find(resource_hash[:id]) if resource_hash and resource_hash[:id]
      need     = match.need     = Need.find(need_hash[:id])    if need_hash and need_hash[:id]

      if !resource and resource_hash and resource_hash[:description] and user.can_create?(Resource)
        resource = match.resource = Resource.build_from(need, resource_hash, user) if need
      end

      if !need and need_hash and need_hash[:description] and user.is_organization_user?
        need = match.need = Need.build_from(resource, need_hash, user) if resource
      end

      match.category = need.try(:category)
      match
    end
  end
end
