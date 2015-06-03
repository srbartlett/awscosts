require 'spec_helper'

describe AWSCosts::EC2OnDemand do

  [:windows, :linux, :windows_with_sql, :windows_with_sql_web, :rhel, :sles].each do |type|
    context "EC2 type of #{type}" do
      use_vcr_cassette

      AWSCosts::Region::SUPPORTED.keys.each do |region|
        context "in the region of #{region}" do
          subject { AWSCosts.region(region).ec2.on_demand(type)}
          it {expect(subject.price).not_to be_empty }
        end
      end
    end
  end
end
