class AccessToken
  include SublimeVideoPrivateApi::Model

  uses_private_api :my # SV app subdomain where model is located.
  collection_path '/private_api/oauth2_tokens'

  scope :valid, -> { where(valid: true) }

  def self.verify(token)
    return false unless token

    find(token)
  rescue Faraday::Error::ResourceNotFound
    false
  end

  def user
    User.find(user_id)
  end

  def expired?
    expires_at.to_i < Time.now.utc.to_i
  end

  def permission_for?(env)
    true
  end

  private

  def expires_at
    if attributes[:expires_at]
      Time.parse(attributes[:expires_at])
    else
      1_000.days.from_now
    end
  end

end
