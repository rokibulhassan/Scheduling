class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_presence_of :email
  mount_uploader :image, ImageUploader
  has_many :authorizations
  has_many :schedules

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0, 10]
        user.name = auth.info.name
        user.email = auth.info.email
        user.remote_avatar_url = auth.info.image.to_s.gsub("_normal", "")
        auth.provider == "twitter" ? user.save(:validate => false) : user.save
      end
      authorization.user_id = user.id
      authorization.username = auth.info.nickname
      authorization.save
    end
    authorization.user
  end

  def self.auth(username)
    Authorization.where(provider: "twitter", username: username).last || nil
  end

  def self.client(username)
    auth = User.auth(username)
    return nil if auth.nil?

    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
      config.access_token = auth.token
      config.access_token_secret = auth.secret
    end
  end
end
