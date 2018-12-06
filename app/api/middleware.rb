# frozen_string_literal: true

require 'action_dispatch'

# Middleware pay attention and validate request HTTP headers and
# add response HTTP headers
#
class Middleware
  include AutoLogger

  def initialize(app)
    @app = app
  end

  def call(env)
    request_headers = ActionDispatch::Http::Headers.from_hash env
    # TODO: validate network header and protocol numbers
    Zoldy.protocol.touch_remote_by_score_header request_headers[Protocol::SCORE_HEADER]

    # Example of remote_ip usage
    #
    # req  = ActionDispatch::Request.new env
    # puts req.remote_ip

    status, response_headers, body = @app.call(env)

    response_headers['Access-Control-Allow-Origin'] = '*'

    Zoldy.protocol.add_response_headers response_headers

    [status, response_headers, body]
  end
end
