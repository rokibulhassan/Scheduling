json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :tweet_at, :twitter_id, :tweet, :image_url
  json.url schedule_url(schedule, format: :json)
end
