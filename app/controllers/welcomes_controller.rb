class WelcomesController < ApplicationController
  def index
    @posted_tweets = current_user.schedules.posted_tweets rescue []
  end

  def profile
    @twitter_profiles = current_user.authorizations rescue []
  end
end
