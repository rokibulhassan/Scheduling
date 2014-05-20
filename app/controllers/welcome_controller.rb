class WelcomeController < ApplicationController
  def index
    #if current_user.present?
      @twitter_profiles = current_user.authorizations rescue []
      @posted_tweets = current_user.schedules.posted_tweets rescue []
    #end
  end
end
