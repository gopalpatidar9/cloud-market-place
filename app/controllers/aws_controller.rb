class AwsController < ApplicationController
    def pricing
        service_code = params[:service_code] # Get the AWS service code from URL params (e.g., EC2, S3, etc.)
        aws_service = AwsPricingService.new
        prices = aws_service.get_prices(service_code)
    
        if prices.present?
          render json: prices, status: :ok
        else
          render json: { error: 'Unable to fetch AWS pricing data' }, status: :bad_request
        end
    end
  end
  