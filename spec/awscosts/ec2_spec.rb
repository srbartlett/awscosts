require 'spec_helper'

describe AWSCosts::EC2 do

  subject { AWSCosts::EC2.new('us-east-1') }

  it { should respond_to(:region) }


end


