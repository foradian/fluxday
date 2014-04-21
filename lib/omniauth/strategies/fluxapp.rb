module OmniAuth
  module Strategies
    class Fluxapp < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :fluxapp

      option :client_options, {
          :site => "http://192.168.1.19:3000",
          :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
            :email => raw_info["email"],
            :name => raw_info["name"],
            :nickname => raw_info["nickname"]
            # and anything else you want to return to your API consumers
        }
      end

      #def callback_phase
      #  p params['code']
      #end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end
  end
end
