require 'httparty'

class GcpPricingService
  include HTTParty
  base_uri 'https://cloudbilling.googleapis.com/v1/services'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_prices(service_id)
    response = self.class.get("/#{service_id}/skus?key=#{@api_key}")
    return JSON.parse(response.body) if response.success?

    {}
  end
end
