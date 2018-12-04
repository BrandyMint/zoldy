# frozen_string_literal: true

# Remote node description model
#
class Remote
  attr_reader :host, :port

  delegate :hash, :to_s, to: :home

  def self.build_from_score(score)
    new(
      host: score.host,
      port: score.port,
      score: score.value
    )
  end

  def self.parse(home)
    host, port = home.split ':'
    new host: host, port: port
  end

  def initialize(host:, port:, score: nil)
    @host = host
    @port = port.to_i
    @score = score
  end

  def ==(other)
    home == other.home
  end

  def ping!
    client.get
  end

  def client
    HttpClient.new uri, protocol: Zoldy.protocol
  end

  def uri
    URI.parse home
  end

  def home
    "http://#{host}:#{port}"
  end

  def errors
    0 # TODO
  end

  def score
    0 # TODO
  end

  def default?
    false # TODO
  end

  def as_json
    {
      host: host,
      port: port,
      score: score,
      errors: errors,
      default: default?,
      home: uri
    }
  end
end
