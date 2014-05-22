class Schedule < ActiveRecord::Base
  belongs_to :user
  #scope :up_coming, -> { where('tweet_at >= ? AND tweet_at <=?', Time.now, Time.now+10.minutes) }
  scope :up_coming, -> { where(:tweet_at => 5.minutes.ago..Time.now+5.minutes) }
  scope :posted_tweets, -> { where(:status => true) }
  scope :not_tweet, -> { where(:status => false) }

  def self.validate_headers(row)
    regex = "/^tweet_at\,screen_name\,twitter_id\,tweet\,image_url$/"
    row.headers.each do |hdr|
      raise "Invalid header #{hdr}" if regex.match(hdr).nil?
    end
  end

  def self.import(file, current_user)
    CSV.foreach(file.path, headers: true) do |row|
      Schedule.validate_headers(row)
      schedule=Schedule.new(row.to_hash)
      schedule.user=current_user
      schedule.save!
    end
  end

  def self.tweet(client, tweet, image_url)
    if image_url.empty?
      client.update(tweet)
    else
      client.update_with_media(tweet, open(image_url))
    end
  end

  def self.operation
    Schedule.not_tweet.up_coming.each do |schedule|
      client = User.client(schedule.screen_name)
      if client.present?
        Schedule.tweet(client, schedule.tweet, schedule.image_url)
        schedule.update_attributes!(status: true)
      end
    end
  end
end
