class ShortenedUrl < ActiveRecord::Base
  extend SecureRandom
  validates :submitter_id, presence: true
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, length: { maximum: 1024 }
  belongs_to(:submitter,
             class_name: 'User',
             foreign_key: :submitter_id,
             primary_key: :id)
  has_many(:visits,
            class_name: 'Visit',
            foreign_key: :shortened_url_id,
            primary_key: :id)
  has_many(:visitors, Proc.new { distinct }, through: :visits, source: :visitor)
  has_many(:taggings,
           class_name: 'Tagging',
           foreign_key: :url_id,
           primary_key: :id)

  has_many(:tag_topics, through: :taggings, source: :tag_topic)

  def self.random_code
    short = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(:short_url => short)
      short = SecureRandom.urlsafe_base64
    end

    short
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url,
                        short_url: ShortenedUrl.random_code,
                        submitter_id: user.id)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where("visits.created_at >= ?", 10.minutes.ago).count
  end

end
