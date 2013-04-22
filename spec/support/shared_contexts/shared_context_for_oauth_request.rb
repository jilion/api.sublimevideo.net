shared_context 'private API stubbed calls' do
  let(:user)  { User.new(id: 1) }
  let(:token) { AccessToken.new(user_id: user.id, token: 'abcd1234', expires_at: 1.hour.from_now) }

  before do
    @sites = [
      Site.new(token: 'abcd1234', hostname: 'rymai.me', accessible_stage: 'beta',
               extra_hostnames: '', dev_hostnames: '', staging_hostnames: '', wildcard: true, path: nil),
      Site.new(token: '1234abcd', hostname: 'rymai.com', accessible_stage: 'alpha',
               extra_hostnames: 'rymai.org, rymai.net', dev_hostnames: 'rymai.dev, remy.dev',
               staging_hostnames: 'staging.rymai.com, staging.rymai.me', wildcard: false, path: 'blog')
    ]

    stub_api_for(User) do |stub|
      stub.get("/private_api/users/#{user.id}") { |env| [200, {}, user.to_json] }
    end

    stub_api_for(Site) do |stub|
      route_prefix = "/private_api/users/#{user.id}/sites"
      stub.get(route_prefix) { |env| [200, {}, @sites.to_json] }
      stub.get("#{route_prefix}/foo") { |env| [404, {}, {}.to_json] }
      if @sites.many?
        stub.get("#{route_prefix}/#{@sites.first.token}") { |env| [200, {}, @sites.first.to_json] }
        stub.get("#{route_prefix}/#{@sites.last.token}") { |env| [200, {}, @sites.last.to_json] }
      end
    end

    stub_api_for(AccessToken) do |stub|
      stub.get("/private_api/oauth2_tokens/foo") { |env| [404, {}, {}.to_json] }
      stub.get("/private_api/oauth2_tokens/#{token.token}") { |env| [200, {}, token.to_json] }
    end
  end
end

shared_context 'valid authenticated request' do
  include_context 'private API stubbed calls'
  before do
    header 'Authorization', "Bearer #{token.token}"
  end
end
