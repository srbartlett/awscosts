require 'spec_helper'

describe AWSCosts::Region do

  subject { AWSCosts::Region.find('us-east-1') }

  it { should respond_to(:name) }
  it { should respond_to(:full_name) }

  describe '.find' do

    describe 'for a supported region' do
      it 'should be an instance of Region' do
        subject.should be_a(AWSCosts::Region)
      end
    end
    describe 'for an unsupported region' do
      it 'should return nothing' do
        AWSCosts::Region.find('NotValid').should be_nil
      end
    end
  end

  describe '.ec2' do
    it 'should be an instance of EC2' do
      subject.ec2.should be_a(AWSCosts::EC2)
    end

  end
end


