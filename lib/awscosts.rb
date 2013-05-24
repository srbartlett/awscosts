require "awscosts/version"
require "awscosts/region"
require "awscosts/ec2"

module AWSCosts

  extend self

  def region name
    AWSCosts::Region.find name
  end

end
