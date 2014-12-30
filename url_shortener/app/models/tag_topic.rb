class TagTopic < ActiveRecord::Base
  validates :tag, presence: true
  has_many(:taggings,
            class_name:  'Tagging',
            foreign_key: :tag_topic_id,
            primary_key: :id)
  has_many(:urls, through: :taggings, source: :url)

  def self.display_topics
    TagTopic.all.each do |tag_topic|
      puts "#{tag_topic.id} - #{tag_topic.tag}"
    end
    nil
  end

end
