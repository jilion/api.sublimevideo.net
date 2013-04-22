require 'spec_helper'

describe User do
  let(:user) { User.new(id: 1) }
  let(:access_token) { stub(user: user) }
  let(:env) { { 'api.token' => access_token } }

  describe '.authorize!' do
    context 'env without api.token key' do
      it 'returns nil' do
        described_class.authorize!({}).should be_nil
      end
    end

    context 'env with api.token key' do
      it 'returns nil' do
        described_class.authorize!(env).should eq user
      end
    end
  end

  describe '#sites' do
    it 'fetches the sites' do
      Site.should_receive(:all).with(user_id: user.id)

      user.sites
    end
  end

  describe '#site' do
    it 'fetches the site' do
      Site.should_receive(:find).with(1, user_id: user.id)

      user.site(1)
    end
  end

end
