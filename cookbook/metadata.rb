name             'puffin'
maintainer       'Will Fisher'
maintainer_email 'will@gina.alaska.edu'
license          'All rights reserved'
description      'Installs/Configures puffin application server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.2'

supports "centos", ">= 6.0"

depends 'yum-gina'
depends 'yum-epel'
depends 'yum-repoforge'
depends 'nginx'
depends 'redisio'
depends 'chruby'
depends 'unicorn'
depends 'postgresql'
depends 'database'
depends 'build-essential'
