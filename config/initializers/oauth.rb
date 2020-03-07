
OAuth2::Response.register_parser(:json, ['application/json', 'text/javascript', 'application/hal+json', 'application/vnd.collection+json', 'application/vnd.api+json']) do |body|
  MultiJson.load(body)['data']['token'] rescue body # rubocop:disable RescueModifier
end
