class IPGeoLocationService
  def user_state(ip_address)
    get_url("/ipgeo?apiKey=#{ENV['ipgeo_api_key']}&ip=#{ip_address}")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: "https://api.ipgeolocation.io") 
  end
end