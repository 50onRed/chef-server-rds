Chef Server backed by AWS RDS
===========

This cookbook configures a system to be a Chef Server using Amazons RDS for the postgresql database. 

Given an iam key and secret, it will provision the rds instance if it doesn't exist in the account, initialize the chef server schema, and install the appropriate platform-specific chef-server Omnibus package and perform the initial configuration of Chef Server on an AWS elastic compute ubuntu instance.

Using postgres on Amazon RDS offloads DB resource use away from the chef-server host. It also enables various DB functions like scaling, backup, and restore to be done independently of the chef-server installations. Similar configurations can be written for other db service providers.

REQUIREMENTS
============

The cookbook has been tested on the following OS
* Ubuntu 12.04, 12.10 64-bit

The role below depends on the following cookbooks
* aws_rds	
* postgresql
* build-essential

Here's a sample chef role that uses the cookbook 

```ruby
name "chef-server-rds"
description "chef-server-rds"
run_list(
    "recipe[build-essential::default]",
    "recipe[postgresql::client]",
    "recipe[chef-server-rds::default]",
)
default_attributes(
  "build_essential" => {
    "compiletime" => true
  }
)
override_attributes(
  "chef-server" => {
    "configuration" => {
     "notification_email" => "change@email.com",
       "postgresql" => {
          "enable" => false
       }
    },
    "nginx" => {
       "enable_non_ssl" => true,
    },
    "postgresql" => {
      "enable" => false,
    },
  },
  "rds" => {
    "id" => 'opscodechef',
    "dbname" => 'opscode_chef',
    "username" => 'test_user',
    "password" => 'test_password',
    "key" => 'iam_key',
    "secret" => 'iam_secret'
   }
)
```

The role can then simply be run to configure both the RDS instance and the chef-server that uses it 

```
knife ec2 server create -r "role[chef-server-rds]" -I ami-b66ca0de -G xyzGroup -S xyzKey -x ubuntu -f m3.medium -N chef_server_name
```
