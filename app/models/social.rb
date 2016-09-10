class Social < ActiveRecord::Base
  has_and_belongs_to_many :users

  #Removing Protected
  #attr_accessible :name, :provider, :uid,:token,:secret, :expires_at
  def self.find_for_facebook_oauth(auth, signed_in_resource)
    social_login = Social.where(:provider => auth.provider, :uid => auth.uid).first
    if social_login
    return signed_in_resource
    else
      ActiveRecord::Base.transaction do
      # player = Player.create(name:auth.extra.raw_info.name,
      #                        picture: URI.parse("http://graph.facebook.com/"+ auth.uid + "/picture?type=large"))
        social_login = Social.create(name:auth.extra.raw_info.name,
        provider:auth.provider,
        uid:auth.uid,
        token: auth.credentials.token,
        expires_at: auth.credentials.expires_at
        )

        signed_in_resource.socials << social_login
        return signed_in_resource
      end

    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource)
    data = access_token.info
    social_login = Social.where(:provider => access_token.provider, :uid => access_token.uid ).first

    if social_login
    return signed_in_resource
    else
      ActiveRecord::Base.transaction do
        social_login = Social.create(name:access_token.info.name,
        provider:access_token.provider,
        uid:access_token.uid ,
        token: access_token.credentials.token,
        refresh_token: access_token.credentials.refresh_token,
        expires_at: access_token.credentials.expires_at
        )

        signed_in_resource.socials << social_login
        return signed_in_resource
      end
    end
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource)

    social_login = Social.where(:provider => auth.provider, :uid => auth.uid).first
    if social_login
    return signed_in_resource
    else
      ActiveRecord::Base.transaction do
        social_login = Social.create(name:auth.info.name,
        provider:auth.provider,
        uid:auth.uid,
        token:auth.credentials.token,
        secret:auth.credentials.secret
        )
        signed_in_resource.socials << social_login
        return signed_in_resource
      end
    end

  end

end
