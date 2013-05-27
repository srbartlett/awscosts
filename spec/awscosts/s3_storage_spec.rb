require 'spec_helper'

describe AWSCosts::S3Storage do
  use_vcr_cassette

  subject { AWSCosts.region('ap-northeast-1').s3.storage}

  its(:price) { should have_key('firstTBstorage') }
  its(:price) { should have_key('next49TBstorage') }
end


