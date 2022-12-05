class MarvelApi::V1::Client
  class MarvelApiError < StandardError; end
  class CharacterNotFound < MarvelApiError; end
  
  BASE_URL = 'https://gateway.marvel.com:443'.freeze
  TS = '1'
  API_KEY = Rails.application.credentials.marvel_client[:api_key]
  HASH =  Rails.application.credentials.marvel_client[:hash]

  ERROR_CODES = {
    404 => CharacterNotFound
  }.freeze

  def characters(orderBy='name', limit=20, offset=rand(1542))
    request(
      method: "get", 
      endpoint: "v1/public/characters", 
      params: { orderBy: orderBy, limit: limit, offset: offset }
    )
  end

  def character(id)
    request(
      method: "get", 
      endpoint: "v1/public/characters/#{id}"
    )
  end

  def comics(issue_format='comic', orderBy='title', limit=20, offset=rand(43824))
    request(
      method: "get", 
      endpoint: "v1/public/comics", 
      params: { format: issue_format, orderBy: orderBy, limit: limit, offset: offset }
    )
  end

  def comic(id)
    request(
      method: "get", 
      endpoint: "v1/public/comics/#{id}"
    )
  end

  def comics_of_a_character(id)
    request(
      method: "get", 
      endpoint: "v1/public/characters/#{id}/comics"
    )
  end

  def characters_in_a_comic(id)
    request(
      method: "get", 
      endpoint: "v1/public/comics/#{id}/characters"
    )
  end


  private

  def request(method:, endpoint:, params: {})
    response = connection.public_send(method, "#{endpoint}") do |request|
      params.each do |k,v|
        request.params[k] = v
      end
    end
    return JSON.parse(response.body) if response.success?
    raise ERROR_CODES[response.status]
  end

  def connection
    @connection ||= Faraday.new(
      url: BASE_URL,
      params: {
        ts: TS,
        apikey: API_KEY,
        hash: HASH
      }
    )
  end
end