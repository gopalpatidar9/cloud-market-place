class AzureController < ApplicationController
    def pricing
      azure_service = AzurePricingService.new
      prices = azure_service.get_prices
  
      if prices.present?
        render json: prices, status: :ok 
      else
        render json: { error: 'Unable to fetch Azure pricing data' }, status: :bad_request
      end
    end
  end
  