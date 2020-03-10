require 'rails_helper'

RSpec.describe Widget do
  include_context 'authenticable_api'

  before do
    stub_request(:any, /#{Authentication.api_base_url}/).to_rack(FakeShowoff)
    authorize!
  end

  describe '#all' do
    include_examples 'unauthorized_credentials_raise_an_error', :all

    it 'returns valid widgets when call showoff api with valid credentials' do
      widgets = described_class.all
      expect(widgets.size).to be(3)
    end
  end

  describe '#find' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      described_class.find(1723)
    }

    it 'returns valid widgets when call showoff api with valid credentials' do
      widget = described_class.find(1723)

      expect(widget.id).to eq(1723)
      expect(widget.name).to eq("A Visible Widget")
      expect(widget.description).to eq("Widget Green")
      expect(widget.kind).to eq("visible")

      expect(widget.user.valid?).to be_truthy
      expect(widget.user.images.valid?).to be_truthy
    end
  end

  describe '#own_widgets' do
    include_examples 'unauthorized_credentials_raise_an_error', :own_widgets

    it 'returns valid widgets when call showoff api with valid credentials' do
      widgets = described_class.own_widgets

      expect(widgets.map(&:user).map(&:id).uniq).to eq([3424])
    end
  end

  describe '#by_user_id' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      described_class.by_user_id(123)
    }

    it 'returns valid widgets when call showoff api with valid credentials' do
      widgets = described_class.by_user_id(123)
      expect(widgets.map(&:user).map(&:id).uniq).to eq([123])
    end
  end

  describe '#create!' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      widget = described_class.new(
        name: "A Hidden Widget",
        description: "Widget 1",
        kind: "hidden"
      )

      widget.create!
    }

    it 'returns valid widgets when call showoff api with valid credentials' do
      widget = described_class.new(
        name: "A Hidden Widget",
        description: "Widget 1",
        kind: "hidden"
      )

      widget.create!

      expect(widget.id).to eq(14771)
      expect(widget.name).to eq("A Hidden Widget")
      expect(widget.description).to eq("Widget 1")
      expect(widget.kind).to eq('hidden')
    end
  end

  describe '#update!' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      widget = described_class.new(
        id: 1723,
        name: 'test',
        description: "Widget 1",
        kind: "hidden"
      )

      widget.update!
    }

    it 'raises an error when try to update an invalid resource' do
      expect {
        widget = described_class.new(
          id: 9999999,
          name: 'Test',
          description: "Widget 1",
          kind: "hidden"
        )

        widget.update!
      }.to raise_error(
        Faraday::UnprocessableEntityError,
        "the server responded with status 422"
      )
    end

    it 'returns valid widgets when call showoff api with valid credentials' do
      widget = described_class.new(
        id: 1723,
        name: "A Visible Widget 22",
        description: "Widget 2222",
        kind: "hidden"
      )

      widget.update!

      expect(widget.id).to eq(1723)
      expect(widget.name).to eq("A Visible Widget 22")
      expect(widget.description).to eq("Widget 2222")
      expect(widget.kind).to eq("hidden")
    end
  end

  describe '#only_visible' do
    include_examples 'unauthorized_credentials_raise_an_error', :only_visible

    it 'returns valid widgets when call showoff api with valid credentials' do
      widgets = described_class.only_visible

      expect(widgets.size).to eq(20)
      expect(widgets.map(&:valid?).uniq).to be_truthy
    end
  end

  describe '#only_visible(term)' do
    include_examples 'unauthorized_credentials_raise_an_error', -> {
      described_class.only_visible('show')
    }

    it 'returns valid widgets when call showoff api with valid credentials' do
      widgets = described_class.only_visible('show')

      expect(widgets.size).to eq(2)
      expect(widgets.map(&:valid?).uniq).to be_truthy
    end
  end
end
