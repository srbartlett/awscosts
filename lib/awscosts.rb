require "awscosts/version"
require "awscosts/region"
require "awscosts/ec2"
require "awscosts/emr"
require "awscosts/s3"
require "awscosts/cache"

module AWSCosts

  extend self

  def region name
    AWSCosts::Region.find name
  end

end
