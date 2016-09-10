class Connect < ActiveRecord::Base
  has_and_belongs_to_many :businesses
  
  def self.find_for_facebook_oauth(auth, signed_in_resource)
    connect_login = Connect.where(:provider => auth.provider, :uid => auth.uid).first
    if connect_login
    return signed_in_resource
    else
      ActiveRecord::Base.transaction do
      # player = Player.create(name:auth.extra.raw_info.name,
      #                        picture: URI.parse("http://graph.facebook.com/"+ auth.uid + "/picture?type=large"))
        connect_login = Connect.create(name:auth.extra.raw_info.name,
        provider:auth.provider,
        uid:auth.uid,
        token: auth.credentials.token,
        expires_at: auth.credentials.expires_at
        )

        signed_in_resource.connects << connect_login
        return signed_in_resource
      end

    end
  end

end
