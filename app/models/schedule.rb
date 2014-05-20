class Schedule < ActiveRecord::Base
  belongs_to :user
  #scope :up_coming, -> { where('tweet_at >= ? AND tweet_at <=?', Time.now, Time.now+10.minutes) }
  scope :up_coming, -> { where(:tweet_at => 5.minutes.ago..Time.now+5.minutes) }
  scope :posted_tweets, -> { where(:status => true) }
  scope :not_tweet, -> { where(:status => false) }

  def self.import(file, current_user)
    CSV.foreach(file.path, headers: true) do |row|
      schedule=Schedule.new(row.to_hash)
      schedule.user=current_user
      schedule.save!
    end
  end

  def self.tweet(username, tweet, image_url)
    client = User.client(username)
    if client.present?
      if image_url.empty?
        client.update(tweet)
      else
        client.update_with_media(tweet, open(image_url))
      end
    end
  end

  def self.operation
    Schedule.not_tweet.up_coming.each do |schedule|
      Schedule.tweet(schedule.twitter_id, schedule.tweet, schedule.image_url)
      schedule.update_attributes!(status: true)
    end
  end
end
