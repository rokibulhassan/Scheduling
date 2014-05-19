class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :tweet_at
      t.string :twitter_id
      t.text :tweet
      t.string :image_url

      t.timestamps
    end
  end
end
