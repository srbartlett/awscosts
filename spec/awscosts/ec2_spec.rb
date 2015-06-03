require 'spec_helper'

describe AWSCosts::EC2 do

  AWSCosts::Region::SUPPORTED.keys.each do |region|
    context "in the region of #{region}" do
    subject { AWSCosts::EC2.new(region) }

    it { should respond_to(:region) }
    end
  end


end


