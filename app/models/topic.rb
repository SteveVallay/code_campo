class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::NumberId

  field :title
  field :content
  field :tags,       :type => Array
  field :actived_at, :type => DateTime
  field :replies_count, :type => Integer, :default => 0

  belongs_to :user
  has_many   :replies

  validates :title, :content, :user, :presence => true
  validates :tag_string, :tag_string => true

  before_create :set_actived_at

  attr_accessible :title, :content, :tag_string

  def tag_string=(string)
    self.tags = string.split(/[,\s]+/).uniq
  end

  def tag_string
    self.tags.to_a.join(', ')
  end

  def set_actived_at
    self.actived_at = Time.now
  end

  def edited?
    updated_at > created_at
  end

  def last_page
    page = (replies_count.to_f / self.class.default_per_page).ceil
    page > 1 ? page : nil
  end

  def last_anchor
    replies_count > 0 ? "replies-#{replies_count}" : nil
  end
end