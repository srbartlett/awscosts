require 'spec_helper'

describe AWSCosts::S3Requests do
  use_vcr_cassette

  subject { AWSCosts.region('ap-northeast-1').s3.requests}

  its(:price) { should have_key('putcopypost') }
end

