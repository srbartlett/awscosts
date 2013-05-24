
class AWSCosts::Region

  attr_reader :name, :full_name, :price_mapping

  SUPPORTED =  {
    'us-east-1' => { :full_name => 'US (Northern Virginia)', :price_mapping => 'us-east' },
    'us-west-1' => { :full_name => 'US (Northern California)', :price_mapping => 'us-west' },
    'us-west-2' => { :full_name => 'US (Oregon)', :price_mapping => 'us-west-2' },
    'eu-west-1' => { :full_name => 'EU (Ireland)', :price_mapping => 'eu-ireland' },
    'ap-southeast-1' => { :full_name => 'Asia Pacific (Singapore)', :price_mapping => 'apac-sin' },
    'ap-southeast-2' => { :full_name => 'Asia Pacific (Sydney)', :price_mapping => 'apac-syd' },
    'ap-northeast-1' => { :full_name => 'Asia Pacific (Tokyo)', :price_mapping => 'apac-tokyo' },
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

  private
  def initialize name
    @name = name
    @full_name = SUPPORTED[name][:full_name]
    @price_mapping = SUPPORTED[name][:price_mapping]
  end

end
