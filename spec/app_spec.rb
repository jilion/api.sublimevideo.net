require 'spec_helper'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

describe 'Outer App' do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  let(:user) { User.new(id: 1) }
  let(:application) { ClientApplication.create!(user_id: user.id, name: 'WordPress plugin', url: 'http://docs.sublimevideo.net/wordpress') }
  let(:token) { Oauth2Token.create!(user_id: user.id, client_application: application) }
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
      stub.get("/private_api/users/#{user.id}/sites") { |env| [200, {}, @sites.to_json] }
    end
  end

  describe '/status' do
    it 'is up' do
      get '/status'

      last_response.status.should eq 200
    end
  end

  describe 'API Authorization' do
    context 'without a token' do
      before { get '/sites' }
      it_behaves_like 'unauthorized response'
    end

    context 'with an invalid token' do
      context 'as a query param' do
        before { get '/sites?access_token=foo' }
        it_behaves_like 'invalid token response'
      end

      context 'as a body param' do
        before { get '/sites', { 'access_token' => 'foo' } }
        it_behaves_like 'invalid token response'
      end

      context 'as an Authorization Bearer header' do
        before do
          header 'Authorization', "Bearer foo"
          get '/sites'
        end
        it_behaves_like 'invalid token response'
      end
    end

    context 'with a valid access token' do
      context 'as a query param' do
        before { get "/sites?access_token=#{token.token}" }
        it_behaves_like 'authorized and valid response on /sites'
      end

      context 'as a body param' do
        before { get '/sites', { 'access_token' => token.token } }
        it_behaves_like 'authorized and valid response on /sites'
      end

      context 'as an Authorization Bearer header' do
        before do
          header 'Authorization', "Bearer #{token.token}"
          get '/sites'
        end
        it_behaves_like 'authorized and valid response on /sites'
      end

      context 'as an Authorization OAuth header (backward-compatibility)' do
        before do
          header 'Authorization', "OAuth #{token.token}"
          get '/sites'
        end
        it_behaves_like 'authorized and valid response on /sites'
      end

    end

    describe 'API formats' do
      before do
        header 'Authorization', "Bearer #{token.token}"
      end

      context 'with a short JSON Accept header' do
        before do
          header 'Accept', 'application/json'
          get '/sites'
        end
        it_behaves_like 'valid JSON response'
      end

      context 'with a short vendor Accept header' do
        before do
          header 'Accept', 'application/vnd.sublimevideo'
          get '/sites'
        end
        it_behaves_like 'valid JSON response'
      end

      context 'with a medium vendor Accept header' do
        before do
          header 'Accept', 'application/vnd.sublimevideo+json'
          get '/sites'
        end
        it_behaves_like 'valid JSON response'
      end

      context 'with a full vendor Accept header' do
        before do
          header 'Accept', 'application/vnd.sublimevideo-v1+json'
          get '/sites'
        end
        it_behaves_like 'valid JSON response'
      end

      context 'with a valid extension' do
        before do
          get '/sites.json'
        end
        it_behaves_like 'valid JSON response'
      end

      context 'with a valid format as a query param' do
        before do
          get '/sites?format=json'
        end
        it_behaves_like 'valid JSON response'
      end

      context 'with an invalid format' do
        before do
          get '/sites.foo'
        end
        it_behaves_like 'valid JSON response'
      end
    end

  end
end

