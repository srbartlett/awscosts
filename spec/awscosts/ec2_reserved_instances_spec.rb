require 'spec_helper'

describe AWSCosts::EC2ReservedInstances do

  describe 'Reserved instances' do

    AWSCosts::Region::SUPPORTED.keys.each do |r|

      context "in the #{r} region" do
        [:windows, :linux, :windows_with_sql, :windows_with_sql_web, :rhel, :sles].each do |type|
          context "EC2 type of #{type}" do
            use_vcr_cassette

            subject { AWSCosts.region(r).ec2.reserved(type)}

            it 'upfront price for 1 year term' do
              subject.upfront(:one_year).should have_key('m1.small')
            end

            it 'upfront price for 3 year term' do
              subject.upfront(:three_year).should have_key('m1.small')
            end

            it 'hourly price for 1 year term' do
              subject.hourly(:one_year).should have_key('m1.small')
            end

            it 'hourly price for 3 year term' do
              subject.hourly(:three_year).should have_key('m1.small')
            end
          end
        end
      end
    end
  end
end
