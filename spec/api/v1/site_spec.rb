require 'spec_helper'
require 'api/v1/site'

describe SublimeVideo::API::V1::Site do
  include Rack::Test::Methods

  def app
    SublimeVideo::API::V1::Site
  end

  include_context 'valid authenticated request'

  describe "GET /sites" do
    context 'without any sites' do
      before { @sites = [] }

      it 'returns an empty array of sites' do
        get '/sites' do |response|
          MultiJson.load(response.body).should eq({ 'sites' => [] })
          response.status.should eq 200
        end
      end
    end

    context 'with sites' do
      before do
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
                wildcard: true, path: '', created_at: '2013-04-23T00:00:00Z'
              },
              {
                token: @sites.last.token, main_domain: @sites.last.hostname,
                accessible_stage: @sites.last.accessible_stage,
                extra_domains: %w[rymai.org rymai.net], dev_domains: %w[rymai.dev remy.dev],
                staging_domains: %w[staging.rymai.com staging.rymai.me],
                wildcard: false, path: 'blog', created_at: '2013-04-24T00:00:00Z'
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
              dev_domains: [], staging_domains: [], wildcard: true, path: '',
              created_at: '2013-04-23T00:00:00Z'
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
              wildcard: false, path: 'blog', created_at: '2013-04-24T00:00:00Z'
            }
          })
        end
      end
    end
  end

end
