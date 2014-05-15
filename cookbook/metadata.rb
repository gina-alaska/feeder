name             'puffin'
maintainer       'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license          'All rights reserved'
description      'Installs/Configures puffin application server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

supports "centos", ">= 6.0"

depends 'yum-gina'
depends 'yum-epel'
depends 'nginx'
depends 'redisio'
depends 'chruby'
depends 'unicorn'
depends 'postgresql'
depends 'database'
depends 'build-essential'
