RSpec.shared_examples "unauthorized_credentials_raise_an_error" do |parameter|
  it 'raises an 401 error when call showoff api with invalid credentials' do
    unauthorize!

    expect {
      if parameter.is_a?(Proc)
        parameter.call
      else
        described_class.send(parameter)
      end
    }.to raise_error(
      Faraday::UnauthorizedError,
      "the server responded with status 401"
    )
  end
end
