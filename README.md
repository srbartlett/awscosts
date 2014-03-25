# AWSCosts

AWSCosts allows programmatic access to AWS pricing.

Useful for calculating the running costs of your fleet of EC2 instances and
associated services such as ELBs, RDS, CloudWatch, etc.

[![Build Status](https://travis-ci.org/srbartlett/awscosts.png)](https://travis-ci.org/srbartlett/awscosts)

## Installation

Add this line to your application's Gemfile:

    gem 'awscosts'

Or install it yourself as:

    $ gem install awscosts

## Usage

Pricing is usually defined by region

    region = AWSCosts.region 'us-east-1'

### On Demand

To find the price of all on-demand EC2 instances running linux

    region.ec2.on_demand(:linux).price

You can pass an argument to price to filter by the instance type.

    region.ec2.on_demand(:linux).price('m1.medium')

### Reserved

To find the **upfront** price of reserving Windows instance for a one year term and light utilization

    region.ec2.reserved(:windows, :light).upfront(:one_year, :light)

To find the **hourly** price of a `m1.large` reserved Windows with SQL instance for
a three year and medium utilization

    region.ec2.reserved(:windows_with_sql, :medium).hourly(:three_year, 'm1.large')

### ELB

To find the hourly price of an ELB in the Sydney region.

    AWSCosts.region('ap-southeast-2').ec2.elb.price_per_hour

To find the price per GB processed of an ELB in the Sydney region.

    AWSCosts.region('ap-southeast-2').ec2.elb.price_per_gb

### EMR

To find the on demand EC2 price and Elastic MapReduce price for the Oregon region.

    AWSCosts.region('us-west-2').emr.ec2_price('cc2.8xlarge')
    AWSCosts.region('us-west-2').emr.emr_price('cc2.8xlarge')

### S3

To find the First 1 TB / month price in the Singapore region which includes the Standard
Storage, Reduced Redundancy Storage, and the Glacier Storage

    AWSCosts.region('ap-southeast-1').s3.storage.price('firstTBstorage')

Pricing is also available for data transfer

    region.s3.data_transfer.price

And request pricing

    region.s3.request.price

### EBS

To find the price of Amazon EBS standard volumes in the Ireland region.

    AWSCosts.region('eu-west-1').ec2.ebs.price(:standard)

`.price` also supports `:provisioned_iops` and `:snapshots_to_s3`

### EIP

To find the price of an non-attached Elastic IP address (EIP) per hour:

    AWSCosts.region('eu-west-1').ec2.elastic_ips.price_non_attached_per_hour

Other pricing available for EIPs includes: `price_additional_per_hour`, `price_remap_first_100`,
`price_remap_over_100` and `price_one`


## Supported Services

The following AWS services are currently support (more to come):

* On-demand instances
* Reserved light utilisation
* Reserved medium utilisation
* Reserved heavy utilisation
* Elastic Load Balancer (ELB)
* Elastic Block Storage (EBS)
* Elastic MapReduce (EMR)
* Elastic IP Address (EIP)
* S3

EC2 platforms:

* Linux (:linux)
* RHEL (:rhel)
* SLES (:sles)
* Windows (:windows)
* Windows with SQL (:windows_with_sql)
* Windows with SQL Web (:windows_with_sql_web)

## Roadmap

Possible items on the roadmap are:

1. Cost calculation using a DSL to describe your AWS environment.
2. Cost calculation from a Cloudformation template.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
