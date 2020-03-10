require 'rails_helper'

RSpec.describe User do
  include_context 'authenticable_api'

  before do
    stub_request(:any, /#{Authentication.api_base_url}/).to_rack(FakeShowoff)
    authorize!
  end

  describe '#find' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      described_class.find(3424)
    }

    it 'returns valid users when call showoff api with valid credentials' do
      user = described_class.find(3424)

      expect(user.id).to eq(3424)
      expect(user.name).to eq("John Lewis")
      expect(user.first_name).to eq("John")
      expect(user.last_name).to eq("Lewis")
      expect(user.date_of_birth).to be_nil
      expect(user.email).to eq('john+123@showoff.ie')
      expect(user.active).to be_truthy

      expect(user.valid?).to be_truthy
      expect(user.images.valid?).to be_truthy
    end
  end

  describe '#me' do
    include_examples 'unauthorized_credentials_raise_an_error', :me

    it 'returns valid users when call showoff api with valid credentials' do
      user = described_class.me

      expect(user.id).to eq(3424)
      expect(user.name).to eq("John Lewis")
      expect(user.first_name).to eq("John")
      expect(user.last_name).to eq("Lewis")
      expect(user.date_of_birth).to be_nil
      expect(user.email).to eq('john+123@showoff.ie')
      expect(user.active).to be_truthy

      expect(user.valid?).to be_truthy
      expect(user.images.valid?).to be_truthy
    end
  end

  describe '#create!' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      user = described_class.new(
        password: 'password',
        first_name: 'first_name1',
        last_name: 'last_name2',
        email: 'first+last12334@gmail.com',
        image_url: "https://static.thenounproject.com/png/961-200.png"
      )
      user.create!
    }

    it 'returns a valid user when call showoff api with valid credentials' do
      user = described_class.new(
        password: 'password',
        first_name: 'John',
        last_name: 'Lewis',
        email: 'john+123@showoff.ie',
        image_url: "https://static.thenounproject.com/png/961-200.png"
      )
      user.create!

      expect(user.id).to eq(14771)
      expect(user.name).to eq('John Lewis')
      expect(user.first_name).to eq(user.first_name)
      expect(user.last_name).to eq(user.last_name)
      expect(user.date_of_birth).to be_nil
      expect(user.email).to eq(user.email)
      expect(user.active).to be_truthy

      expect(user.valid?).to be_truthy
      expect(user.images.valid?).to be_truthy
      expect(user.token).to be_an_instance_of(OAuth2::AccessToken)
    end
  end

  describe '#update!' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      user = described_class.new(
        password: 'password',
        first_name: 'John',
        last_name: 'Lewis',
        email: 'john+123@showoff.ie',
        image_url: "https://static.thenounproject.com/png/961-200.png"
      )
      user.create!
    }

    it 'raises an error when try to update an invalid resource' do
      expect {
        user = described_class.new(
          id: 9999999,
          password: 'password',
          first_name: 'John',
          last_name: 'Lewis',
          email: 'john+123@showoff.ie',
          image_url: "https://static.thenounproject.com/png/961-200.png"
        )
        user.update!
      }.to raise_error(
        Faraday::UnprocessableEntityError,
        "the server responded with status 422"
      )
    end

    it 'returns a valid user when call showoff api with valid credentials' do
      user = described_class.new(
        id: 3424,
        password: 'password',
        first_name: 'John1',
        last_name: 'Lewis2',
        email: 'john+123@showoff.ie',
        image_url: "https://static.thenounproject.com/png/961-200.png"
      )

      user.update!

      expect(user.id).to eq(3424)
      expect(user.name).to_not be_nil
      expect(user.images.original_url).to_not be_nil
      expect(user.email).to eq('john+123@showoff.ie')
      expect(user.password).to be_nil
    end
  end
end
