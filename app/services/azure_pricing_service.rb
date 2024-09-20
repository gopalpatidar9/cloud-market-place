require 'httparty'

class AzurePricingService
  include HTTParty
  base_uri 'https://prices.azure.com'

  def get_prices
    response = self.class.get('/api/retail/prices')
    return JSON.parse(response.body) if response.success?

    {}
  end
end
