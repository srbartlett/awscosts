require 'awscosts/s3_storage'
require 'awscosts/s3_requests'
require 'awscosts/s3_data_transfer'

class AWSCosts::S3

  attr_reader :region

  def initialize region
    @region = region
  end

  def storage
    AWSCosts::S3Storage.fetch(self.region.price_mapping)
  end

  def data_transfer
    AWSCosts::S3DataTransfer.fetch(self.region.price_mapping)
  end

  def requests
    AWSCosts::S3Requests.fetch(self.region.price_mapping)
  end
end



