require 'awscosts/s3_storage'
require 'awscosts/s3_requests'
require 'awscosts/s3_data_transfer'

class AWSCosts::S3

  attr_reader :region

  def initialize region
    @region = region
  end

  def storage
    r = self.region.price_mapping
    r = 'us-std' if r == 'us-east'
    AWSCosts::S3Storage.fetch(r)
  end

  def data_transfer
    r = self.region.price_mapping
    r = 'us-std' if r == 'us-east'
    AWSCosts::S3DataTransfer.fetch(r)
  end

  def requests
    r = self.region.price_mapping
    r = 'us-std' if r == 'us-east'
    AWSCosts::S3Requests.fetch(r)
  end
end



