class Schedule < ActiveRecord::Base

  #scope :up_coming, -> { where('tweet_at >= ? AND tweet_at <=?', Time.now, Time.now+10.minutes) }
  scope :up_coming, -> { where(:tweet_at => 5.minutes.ago..Time.now+5.minutes) }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Schedule.create!(row.to_hash)
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
    Schedule.all.each do |schedule|
      Schedule.tweet(schedule.twitter_id, schedule.tweet, schedule.image_url)
    end
  end
end
