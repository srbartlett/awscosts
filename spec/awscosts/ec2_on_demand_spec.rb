require 'spec_helper'

describe AWSCosts::EC2OnDemand do

  [:windows, :linux, :windows_with_sql, :windows_with_sql_web, :rhel, :sles].each do |type|
    context "EC2 type of #{type}" do
      use_vcr_cassette

      subject { AWSCosts.region('ap-southeast-2').ec2.on_demand(type)}

      its(:price) { should have_key('m1.small') }
    end
  end
end
