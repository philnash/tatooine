module Tatooine
  module Middleware
    class RaiseHttpError < Faraday::Response::Middleware
      def on_complete(env)
        case env[:status].to_i
        when 400
          raise Tatooine::BadRequest, response_values(env)
        when 404
          raise Tatooine::NotFound, response_values(env)
        when 500
          raise Tatooine::InternalServerError, response_values(env)
        when 502
          raise Tatooine::BadGateway, response_values(env)
        when 503
          raise Tatooine::ServiceUnavailable, response_values(env)
        when 504
          raise Tatooine::GatewayTimeout, response_values(env)
        when 521
          raise Tatooine::OriginDown, response_values(env)
        end
      end

      def response_values(env)
        {:status => env.status, :headers => env.response_headers, :body => env.body}
      end
    end
  end
end

module Faraday
  class Response
    register_middleware :raise_http_error => Tatooine::Middleware::RaiseHttpError
  end
end
