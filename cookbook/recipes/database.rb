app_name = "puffin"

include_recipe 'yum-epel'

node[app_name]['databases'].each do |environment, database|
	node.default['postgresql']['pg_hba'] += [{
		'type' => 'host',
		'db' => database['database'],
		'user' => database['username'],
		'addr' => 'all',
		'method' => 'trust'
	},{
		'type' => 'host',
		'db' => 'postgres',
		'user' => database['username'],
		'addr' => 'all',
		'method' => 'trust'
	}]
end

include_recipe "postgresql::server"
include_recipe "database::default"
include_recipe "postgresql::ruby"

app_name = 'puffin'

postgresql_connection_info = {
	host: '127.0.0.1',
	port: 5432,
	username: 'postgres',
	password: node['postgresql']['password']['postgres']
}

node[app_name]['databases'].each do |environment, database|
	# create a postgresql database
	postgresql_database database['database'] do
	  connection postgresql_connection_info
	  action :create
	end

	# Create a postgresql user but grant no privileges
	postgresql_database_user database['username'] do
	  connection postgresql_connection_info
	  password   database['password']
	  action     :create
	end

	# Grant all privileges on all tables in foo db
	postgresql_database_user database['username'] do
	  connection    postgresql_connection_info
	  database_name database['database']
	  privileges    [:all]
	  action        :grant
	end
end
