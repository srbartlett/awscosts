require 'spec_helper'

describe AWSCosts::S3DataTransfer do
  use_vcr_cassette

  subject { AWSCosts.region('ap-northeast-1').s3.data_transfer}

  its(:price) { should have_key('dataXferInS3') }
end


