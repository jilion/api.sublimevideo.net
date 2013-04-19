require 'spec_helper'

describe SublimeVideo::APIs::V1::Site do
  include Rack::Test::Methods

  def app
    SublimeVideo::APIs::V1::Site
  end

  let(:user) { User.new(id: 1) }
  let(:application) { ClientApplication.create!(user_id: user.id, name: 'WordPress plugin', url: 'http://docs.sublimevideo.net/wordpress') }
  let(:token) { Oauth2Token.create!(user_id: user.id, client_application: application) }

  before do
    header 'Authorization', "Bearer #{token.token}"

    @sites = [
      Site.new(token: 'abcd1234', hostname: 'rymai.me', accessible_stage: 'beta',
               extra_hostnames: '', dev_hostnames: '', staging_hostnames: '', wildcard: true, path: nil),
      Site.new(token: '1234abcd', hostname: 'rymai.com', accessible_stage: 'alpha',
               extra_hostnames: 'rymai.org, rymai.net', dev_hostnames: 'rymai.dev, remy.dev',
               staging_hostnames: 'staging.rymai.com, staging.rymai.me', wildcard: false, path: 'blog')
    ]

    stub_api_for(Site) do |stub|
      route_prefix = "/private_api/users/#{user.id}/sites"
      stub.get(route_prefix) { |env| [200, {}, @sites.to_json] }
      stub.get("#{route_prefix}/#{@sites.first.token}") { |env| [200, {}, @sites.first.to_json] }
      stub.get("#{route_prefix}/#{@sites.last.token}") { |env| [200, {}, @sites.last.to_json] }
      stub.get("#{route_prefix}/foo") { |env| [404, {}, @sites.first.to_json] }
    end

    User.should_receive(:authorize!).and_return(user)
  end

  describe "GET /sites" do
    context 'without any sites' do
      before { user.should_receive(:sites).and_return([]) }

      it 'returns an empty array of sites' do
        get '/sites'
        last_response.status.should eq 200
        MultiJson.load(last_response.body).should eq({ 'sites' => [] })
      end
    end

    context 'with sites' do
      before do
        user.should_receive(:sites).and_return(@sites)
        get '/sites'
      end

      it_behaves_like 'authorized and valid response on /sites'

      describe 'response attributes' do
        it 'has the right attributes' do
          body = MultiJson.load(last_response.body, symbolize_keys: true)
          body.should eq({
            sites: [
              {
                token: @sites.first.token, main_domain: @sites.first.hostname,
                accessible_stage: @sites.first.accessible_stage,
                extra_domains: [], dev_domains: [], staging_domains: [],
                wildcard: true, path: ''
              },
              {
                token: @sites.last.token, main_domain: @sites.last.hostname,
                accessible_stage: @sites.last.accessible_stage,
                extra_domains: %w[rymai.org rymai.net], dev_domains: %w[rymai.dev remy.dev],
                staging_domains: %w[staging.rymai.com staging.rymai.me],
                wildcard: false, path: 'blog'
              }
            ]
          })
        end
      end
    end
  end

  describe 'GET /sites/:token' do
    context 'existing token' do
      before do
        @site = @sites.first
        get "/sites/#{@site.token}"
      end

      it_behaves_like 'authorized and valid response on /sites/:token'
    end

    context 'non-existing token' do
      before do
        @site = @sites.first
        get '/sites/foo'
      end

      it_behaves_like 'resource not found response'
    end

    describe 'response attributes' do
      context 'site with missing fields' do
        before do
          @site = @sites.first
          get "/sites/#{@site.token}"
        end

        it 'has the right attributes' do
          body = MultiJson.load(last_response.body, symbolize_keys: true)
          body.should eq({
            site: {
              token: @site.token, main_domain: @site.hostname,
              accessible_stage: @site.accessible_stage, extra_domains: [],
              dev_domains: [], staging_domains: [], wildcard: true, path: ''
            }
          })
        end
      end

      context 'site with fields filled' do
        before do
          @site = @sites.last
          get "/sites/#{@site.token}"
        end

        it 'has the right attributes' do
          body = MultiJson.load(last_response.body, symbolize_keys: true)
          body.should eq({
            site: {
              token: @site.token, main_domain: @site.hostname,
              accessible_stage: @site.accessible_stage,
              extra_domains: %w[rymai.org rymai.net],
              dev_domains: %w[rymai.dev remy.dev],
              staging_domains: %w[staging.rymai.com staging.rymai.me],
              wildcard: false, path: 'blog'
            }
          })
        end
      end
    end
  end

end
