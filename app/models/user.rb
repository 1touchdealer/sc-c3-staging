class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :omniauthable, :recoverable
  include LastPeriods

  belongs_to :region
  belongs_to :location
  belongs_to :alliance
  belongs_to :business
  belongs_to :church
  has_many :subscriptions, dependent: :destroy
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :resources
  has_many :ads
  has_many :user_areas_of_interest
  has_many :areas_of_interest, through: :user_areas_of_interest
  has_many :charitable_donations
  has_many :campaign_donations
  has_many :campaigns
  has_many :attendees
  has_many :payments
  has_many :events
  has_one :job_lead
  has_one :card

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validate :current_password_match
  validates :region, presence: true, if: :user_exist?

  # NOTE: These validations are commented due to old user login issue, and these validations are applied on front-end side 

  # validates :address_line1, presence: true, if: :user_exist?
  # validates :address_city, presence: true, if: :user_exist?
  # validates :address_state, presence: true, if: :user_exist?
  # validates :address_zip, presence: true, if: :user_exist?
  # validate :address_should_be_presence

  accepts_nested_attributes_for :alliance, :business, :church

  after_create :subscribe_user_to_mailing_list

  attr_accessor :terms_accepted, :covenant_accepted, :current_password, :member_type


  # Define convenience methods for roles:
  # User#member?, User#alliance_admin?, User#super_admin?, etc.
  Role::NAMES.each do |name|
    role = Role.send(name)
    define_method("#{name}?") { user_roles.where(role_id: role.id).exists? }
  end

  # def address_should_be_presence
  #   %w(address_line1 address_line2 address_city address_state address_zip).any?
  # end

  # def expiration
  #   read_attribute(:expiration).in_time_zone('UTC')
  # end

  def display_name
    name || email
  end

  # Annual membership fee in cents
  def membership_fee
    if business_admin?
      {"amount" => 29900, "id" => "business-29900"}
    elsif church_admin?
      {"amount" => 9900, "id" => "church-9900"}
    elsif alliance_admin?
      {"amount" => 9900, "id" => "alliance-9900"}
    else
      {"amount" => 4900, "id" => "individual-4900"}
    end
  end

  def paid?
    expiration && expiration > Time.now
  end

  def attending?(event)
    event.is_a?(Event) && event.attendees.where(user_id: id).exists?
  end

  def subscribe_user_to_mailing_list
   SubscribeUserToMailingListJob.perform_later(email: self.email, name: self.name)
  end

  def get_roles
    # Returns role the user has in an array of strings
    roles = [];

    roles.push("Super Admin")    if super_admin?
    roles.push("Alliance Admin") if alliance_admin?
    roles.push("Business Admin") if business_admin?
    roles.push("Church Admin")   if church_admin?
    roles.push("City Director")  if city_director?
    roles.push("State Director") if state_director?
    roles.push("Member")         if member?

    return roles
  end

  def include_any_edit_action? data
    !%w(edit_alliance edit_business edit_church update).include?(data[:action]) && !(data[:controller].eql?('registrations') && data[:action].eql?('edit'))
  end

  private
  def current_password_match
    change = changes[:encrypted_password]
    if !change.present? || new_record? || current_password.nil?
      return
    elsif !Devise::Encryptor.compare(User, change[0], current_password)
      errors.add(:current_password, 'does not match')
    end
  end

  def user_exist?
    persisted?
  end
end
