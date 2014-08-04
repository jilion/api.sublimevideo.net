require 'spec_helper'

describe 'Outer App' do
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file('config.ru').first
  end

  include_context 'private API stubbed calls'

  describe 'headers' do
    describe 'X-Runtime' do
      before { get '/status' }

      it 'contains a X-Runtime header' do
        last_response.headers['X-Runtime'].should be_present
      end
    end

    describe 'Etag' do
      before { get '/status' }

      it 'contains an Etag header' do
        last_response.headers['Etag'].should be_present
      end
    end

    describe 'Cache-Control' do
      before { get '/status' }

      it 'contains an Cache-Control header' do
        last_response.headers['Cache-Control'].should eq 'max-age=0, private, must-revalidate'
      end
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
      include_context 'valid authenticated request'

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
      include_context 'valid authenticated request'

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

