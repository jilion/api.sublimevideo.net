shared_examples 'unauthorized response' do
  it 'returns a 401 Unauthorized' do
    MultiJson.load(last_response.body, symbolize_keys: true).should eq({ error: '401 Unauthorized' })
    last_response.status.should eq 401
  end
end

shared_examples 'invalid token response' do
  it 'returns a 401 Invalid Token' do
    MultiJson.load(last_response.body, symbolize_keys: true).should eq({
      error: 'invalid_token',
      error_description: 'The access token provided is expired, revoked, malformed or invalid for other reasons.'
    })
    last_response.status.should eq 401
  end
end

shared_examples 'authorized and valid response on /sites' do
  it 'returns a 200 and an array of sites' do
    body = MultiJson.load(last_response.body)
    body.should be_a(Hash)
    body['sites'].should be_a(Array)
    @sites.each_with_index do |site, index|
      body['sites'][index]['site']['token'].should eq site.token
      body['sites'][index]['site']['hostname'].should eq site.hostname
    end
    body['sites'].should have(@sites.size).sites
    last_response.status.should eq 200
  end
end

shared_examples 'authorized and valid response on /sites/:token' do
  it 'returns a 200 and a site' do
    body = MultiJson.load(last_response.body)
    body.should be_a(Hash)
    body['site'].should be_a(Hash)
    body['site']['token'].should eq @site.token
    body['site']['hostname'].should eq @site.hostname
    last_response.status.should eq 200
  end
end

shared_examples 'resource not found response' do
  it 'returns a 404 Resource Not Found' do
    MultiJson.load(last_response.body).should eq({ 'error' => '404 Resource Not Found' })
    last_response.status.should eq 404
  end
end

shared_examples 'valid JSON response' do
  it 'has the right content-type and media type' do
    last_response.headers['Content-Type'].should eq 'application/json; charset=UTF-8'
    last_response.headers['X-SublimeVideo-Media-Type'].should eq 'sublimevideo-v1; format=json'
    last_response.status.should eq 200
  end
end
