
class AWSCosts::Region

  attr_reader :name, :full_name, :price_mapping

  SUPPORTED =  {
    'us-east-1' => { :full_name => 'US (Northern Virginia)', :price_mapping => 'us-east-1' },
    'us-west-1' => { :full_name => 'US (Northern California)', :price_mapping => 'us-west-1' },
    'us-west-2' => { :full_name => 'US (Oregon)', :price_mapping => 'us-west-2' },
    'eu-west-1' => { :full_name => 'EU (Ireland)', :price_mapping => 'eu-west-1' },
    'ap-southeast-1' => { :full_name => 'Asia Pacific (Singapore)', :price_mapping => 'ap-southeast-1' },
    'ap-southeast-2' => { :full_name => 'Asia Pacific (Sydney)', :price_mapping => 'ap-southeast-2' },
    'ap-northeast-1' => { :full_name => 'Asia Pacific (Tokyo)', :price_mapping => 'ap-northeast-1' },
    'sa-east-1' => { :full_name => 'South America (Sao Paulo)', :price_mapping => 'sa-east-1' }
  }

  def self.find name
    SUPPORTED[name] ? self.new(name) : nil
  end


  def ec2
    AWSCosts::EC2.new(self)
  end

  def emr
    AWSCosts::EMR.fetch(self.price_mapping)
  end

  def s3
    AWSCosts::S3.new(self)
  end

  private
  def initialize name
    @name = name
    @full_name = SUPPORTED[name][:full_name]
    @price_mapping = SUPPORTED[name][:price_mapping]
  end

end
