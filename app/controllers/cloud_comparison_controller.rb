class CloudComparisonController < ApplicationController
    def compare
      aws_service = AwsPricingService.new
      azure_service = AzurePricingService.new
      gcp_service = GcpPricingService.new('YOUR_GCP_API_KEY')
  
      aws_data = aws_service.get_prices('AmazonEC2')
      azure_data = azure_service.get_prices
      gcp_data = gcp_service.get_prices('YOUR_SERVICE_ID')
  
      @comparison_results = compare_cloud_services(aws_data, azure_data, gcp_data)
    end
  
    private
  
    def compare_cloud_services(aws_data, azure_data, gcp_data)
      aws_price = extract_price_from_aws(aws_data)
      azure_price = extract_price_from_azure(azure_data)
      gcp_price = extract_price_from_gcp(gcp_data)
  
      {
        aws: aws_price,
        azure: azure_price,
        gcp: gcp_price
      }
    end
  
    def extract_price_from_aws(data)
      data['terms']['OnDemand'].first[1]['priceDimensions'].first[1]['pricePerUnit']['USD']
    end
  
    def extract_price_from_azure(data)
      data['Items'].first['retailPrice']
    end
  
    def extract_price_from_gcp(data)
      data['skus'].first['pricing']['pricingExpression']['tieredRates'].first['unitPrice']['units']
    end
end
  