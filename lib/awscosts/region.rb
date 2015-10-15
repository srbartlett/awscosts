
class AWSCosts::Region

  attr_reader :name, :full_name, :price_mapping, :emr_mapping

  SUPPORTED =  {
    'us-east-1' => { :full_name => 'US (Northern Virginia)' },
    'us-west-1' => { :full_name => 'US (Northern California)' },
    'us-west-2' => { :full_name => 'US (Oregon)' },
    'eu-west-1' => { :full_name => 'EU (Ireland)' },
    'eu-central-1' => { :full_name => 'EU (Frankfurt)' },
    'ap-southeast-1' => { :full_name => 'Asia Pacific (Singapore)' },
    'ap-southeast-2' => { :full_name => 'Asia Pacific (Sydney)' },
    'ap-northeast-1' => { :full_name => 'Asia Pacific (Tokyo)' },
    'sa-east-1' => { :full_name => 'South America (Sao Paulo)' }
  }

  def self.find name
    SUPPORTED[name] ? self.new(name) : nil
  end


  def ec2
    AWSCosts::EC2.new(self)
  end

  def emr
    AWSCosts::EMR.fetch(self.name)
  end

  def s3
    AWSCosts::S3.new(self)
  end

  private
  def initialize name
    @name = name
    @full_name = SUPPORTED[name][:full_name]
    @price_mapping = SUPPORTED[name][:price_mapping]
    @emr_mapping = SUPPORTED[name][:emr_mapping]
  end

end
