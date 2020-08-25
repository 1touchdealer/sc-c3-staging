class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :region
  has_many :attendance_levels
  has_many :attendees

  scope :approved, -> { where(approved: true) }

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ":class/:attachment/default/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :name, presence: true
  validates :start, presence: true
  # validates :attendance_levels, length: {minimum: 1}

  accepts_nested_attributes_for :attendance_levels, allow_destroy: true

  def self.upcoming(limit)
    collection = approved.
      where('start > ?', Time.now).
      order('start asc').
      limit(limit)
    if collection.count == limit
      collection
    else
      where(id: approved.order('start desc').limit(limit)).
        order('start asc')
    end
  end
end
