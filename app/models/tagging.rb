class Tagging < ActiveRecord::Base
  validates :tag_topic_id, presence: true
  validates :url_id, presence: true
  belongs_to(:tag_topic,
             class_name: 'TagTopic',
             foreign_key: :tag_topic_id,
             primary_key: :id)

  belongs_to(:url,
             class_name: 'ShortenedUrl',
             foreign_key: :url_id,
             primary_key: :id)

 def self.record_tag!(tag, url)
   Tagging.create!(tag_topic_id: tag.id, url_id: url.id)
 end

end
