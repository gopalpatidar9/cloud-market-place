require 'httparty'

class AwsPricingService
  include HTTParty
  base_uri 'https://pricing.us-east-1.amazonaws.com'

  def initialize
    @options = { query: { format: 'json' } }
  end

  def get_prices(service_code)
    response = self.class.get("/offers/v1.0/aws/#{service_code}/current/index.json", @options)

    Rails.logger.info "AWS Pricing Response Code: #{response.code}"
    Rails.logger.info "AWS Pricing Response Body: #{response.body}"

    return JSON.parse(response.body) if response.success?
    {}
  end
end
