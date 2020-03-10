require 'sinatra/base'

class FakeShowoff < Sinatra::Base
  thread_cattr_accessor :valid_token, :client_id, :client_secret

  before '*' do
    authenticate!
  end

  get '/api/v1/widgets' do
    json_response 200, 'widgets.json'
  end

  get '/api/v1/widgets/visible' do
    if (params[:client_id] || params[:client_secret]).blank?
      return error_401
    end

    if params[:term].present?
      json_response 200, 'widgets_visible_show.json'
    else
      json_response 200, 'widgets_visible.json'
    end
  end

  get '/api/v1/widgets/:id' do
    json_response 200, 'widget_1723.json'
  end

  get '/api/v1/users/me/widgets' do
    json_response 200, 'widgets.json'
  end

  get '/api/v1/users/:user_id/widgets' do
    data = json_fixture('widgets.json')
    data[:data][:widgets].each do |widget|
      widget[:user][:id] = params[:user_id].to_i
    end

    content_type :json
    status 200
    data.to_json
  end

  post '/api/v1/widgets' do
    data = json_fixture('widget_1723.json')

    data[:data][:widget].tap do |widget|
      widget[:id] = 14771
      widget.merge! request_payload[:widget].slice(:name, :description, :kind)
    end

    content_type :json
    status 200
    data.to_json
  end

  put '/api/v1/widgets' do
    data = json_fixture('widget_1723.json')

    data[:data][:widget].tap do |widget|
      widget[:id] = 14771
      widget.merge! request_payload[:widget].slice(:name, :description, :kind)
    end

    content_type :json
    status 200
    data.to_json
  end

  put '/api/v1/widgets/:widget_id' do
    data = json_fixture('widget_1723.json')

    if params[:widget_id] == '9999999'
      halt 422
    elsif params[:widget_id] == '1723'
      data[:data][:widget].tap do |widget|
        widget.merge! request_payload[:widget].slice(:name, :description, :kind)
      end
    end

    content_type :json
    status 200
    data.to_json
  end

  private

    def request_payload
      @request_payload ||= begin
        request.body.rewind

        JSON.parse(request.body.read, symbolize_names: true)
      end
    end

    def json_response(response_code, file_name)
      content_type :json
      status response_code
      read_fixture(file_name)
    end

    def read_fixture(file_name)
      File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
    end

    def json_fixture(file_name)
      data = read_fixture(file_name)
      JSON.parse(data, symbolize_names: true)
    end

    def authenticate!
      if valid_token.present? &&
         request.env["HTTP_AUTHORIZATION"] == "Bearer #{valid_token}"
        return
      end

      error_401
    end

    def error_401
      halt 401, {
        code: 10,
        message: "Your session has expired. Please login again to continue.",
        data: nil
      }.to_json
    end
end
