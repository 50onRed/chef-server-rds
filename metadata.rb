name              'chef-server-rds'
maintainer        'Bradley Wangia'
maintainer_email  'bradley.wangia@gmail.com'
license           'Apache 2.0'
description       'Installs and configures Chef Server backed by Amazon RDS Postgresql'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.0.1'

supports 'ubuntu'

# depends 'git'
depends 'aws_rds'
