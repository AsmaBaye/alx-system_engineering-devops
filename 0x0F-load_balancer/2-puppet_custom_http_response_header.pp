# Installs and Configures an nginx web server
exec { 'update':
    command => '/usr/bin/env apt-get -y update',
}

package { 'nginx' :
  ensure     => installed,
  require    => Exec['update']
}

file { 'Configure index.html':
  path       => '/var/www/html/index.html',
  ensure     => present,
  content    => 'Hello World!',
}

file_line { 'Customer Header':
  path       => '/etc/nginx/sites-available/default',
  ensure     => present,
  after      => 'server_name _;',
  line       => "\tadd_header X-Served-By ${hostname};",
  require    => Package['nginx']
}

service { 'nginx' :
  ensure     => running,
  require    => File_line['Customer Header']
}
