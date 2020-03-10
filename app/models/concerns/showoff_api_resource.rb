module ShowoffApiResource
  extend ActiveSupport::Concern

  included do
    def destroy!
      self.class.destroy!(id)
    end

    def create(params)
      if valid?(:create)
        self.class.create!(params)
      else
        false
      end
    end

    def update(id, params)
      if valid?(:update)
        self.class.update!(id, params)
      else
        false
      end
    end
  end

  # rubocop:disable Metrics/BlockLength
  class_methods do
    def find(id, params = {})
      response = client_api.get("#{plural_name}/#{id}", params)
      convert_to_objects(response)
    end

    def all(
      params: {},
      path: plural_name,
      skip_access_token: false,
      include_query_credentials: false
    )
      request_params = params.dup

      if include_query_credentials
        request_params.merge!(
          client_id: Authentication.oauth2_client.id,
          client_secret: Authentication.oauth2_client.secret
        )
      end

      response = client_api(skip_access_token: skip_access_token).get(
        path,
        request_params
      )

      convert_to_objects(response)
    end

    def create!(params)
      response = client_api.post(plural_name, params)
      convert_to_objects(response)
    end

    def update!(id, params)
      response = client_api.put("#{plural_name}/#{id}", params)
      convert_to_objects(response)
    end

    def destroy!(id)
      response = client_api.delete("#{plural_name}/#{id}")
      response.body[:message] == 'Success'
    end

    private

      def plural_name
        self.model_name.plural
      end

      def convert_to_objects(response)
        root = response.body[:data]
        token = root[:token]

        data = root.values.first
        klass = klass_from_root(root)

        if data.is_a?(Array)
          data.map do |entry|
            klass.new(entry)
          end
        elsif klass.is_a?(User)
          klass.new(data).tap do |user|
            user.token = token
          end
        else
          klass.new(data)
        end
      end

      def klass_from_root(root)
        klass_type = root.keys.first
        klass_name = klass_type.to_s.classify
        klass_name.constantize
      end

      def client_api(skip_access_token: false)
        Faraday.new api_base_url do |conn|
          if !skip_access_token && Authentication.access_token.present?
            check_token_expired

            conn.request(
              :oauth2,
              Authentication.access_token.token,
              token_type: 'bearer'
            )
          end

          conn.request :json

          conn.response :logger, Rails.logger, bodies: true
          conn.response :raise_error
          conn.response :json, parser_options: { symbolize_names: true }

          # conn.use :instrumentation
          conn.adapter Faraday.default_adapter
        end
      end

      def api_base_url
        Authentication.api_base_url
      end

      def check_token_expired
        if Authentication.access_token.expired?
          Authentication.access_token.refresh!
        end
      end
  end
  # rubocop:enable Metrics/BlockLength
end
