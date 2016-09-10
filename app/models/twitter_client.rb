require 'twitter'

class TwitterClient
  def initialize(social)
    @social =  social
  end

  def tweet(message)
    id = api_client.update(message)
    return id
  end

def get_tweet(id)
    tweet = api_client.status(id)
  return tweet
end

  private

  def api_client
    @client ||= begin
    client = Twitter::REST::Client.new do |config|
    config.consumer_key        = API_KEYS['twitter']['api_key']
    config.consumer_secret     = API_KEYS['twitter']['api_secret'] 
    config.access_token        = @social.token
    config.access_token_secret = @social.secret
    end
    client
    end
  end
end