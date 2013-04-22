require 'spec_helper'

describe AccessToken do
  let(:user) { User.new(id: 1) }
  let(:access_token) { AccessToken.new }

  describe '.verify' do
    let(:access_token) { AccessToken.new(access_token: 'abcd1234', user_id: user.id) }

    context 'nil token' do
      it 'returns false' do
        described_class.verify(nil).should be_false
      end
    end

    context 'false token' do
      it 'returns false' do
        described_class.verify(false).should be_false
      end
    end

    context 'existing token' do
      before { described_class.should_receive(:find).with('abcd1234').and_return(access_token) }

      it 'returns the access_token' do
        described_class.verify(access_token.access_token).should eq access_token
      end
    end

    context 'non existing token' do
      before do
        described_class.should_receive(:find).with('abcd1234')
        .and_raise(Faraday::Error::ResourceNotFound, '')
      end

      it 'returns the access_token' do
        described_class.verify(access_token.access_token).should be_false
      end
    end
  end

  describe '#user' do
    let(:access_token) { AccessToken.new(access_token: 'abcd1234', user_id: user.id) }

    it 'fetches the User' do
      User.should_receive(:find).with(user.id)

      access_token.user
    end
  end

  describe '#expired?' do
    context 'without an expired_at' do
      subject { AccessToken.new(access_token: 'abcd1234') }

      it { should_not be_expired }
    end

    context 'with an expired_at not expired' do
      subject { AccessToken.new(access_token: 'abcd1234', expires_at: 3.days.from_now.to_s) }

      it { should_not be_expired }
    end

    context 'with an expired_at expired' do
      subject { AccessToken.new(access_token: 'abcd1234', expires_at: 3.days.ago.to_s) }

      it { should be_expired }
    end
  end

  describe '#permission_for?' do
    context 'without an expired_at' do
      it 'returns true' do
        access_token.permission_for?([]).should be_true
      end
    end
  end

end
