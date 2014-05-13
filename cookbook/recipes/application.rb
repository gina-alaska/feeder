include_recipe 'puffin::packages'
include_recipe 'puffin::ruby'

include_recipe 'puffin::_database_common'
include_recipe 'postgresql::client'

include_recipe 'build-essential'

directory "/www"

app_name = "puffin"
account = node[app_name]['account']

%w{ application_path shared_path config_path initializers_path deploy_path }.each do |dir|
  directory node[app_name][dir] do
    owner account
    group account
    mode 00755
    action :create
  end
end


directory node[app_name]['puffin_silo_path'] do
  action :create
  recursive true
end

service 'rpcbind' do
  action [:enable, :start]
end

template "#{node[app_name]['shared_path']}/config/sunspot.yml" do
  owner account
  group account
  mode 00644  
  variables(
    :production_host => node[app_name]["sunspot"]["hostname"],
    :production_port => node[app_name]["sunspot"]["port"]
  )
end

template "#{node[app_name]['shared_path']}/config/database.yml" do
  owner account
  group account
  mode 00644    
  variables({
    environment: node[app_name]['environment'],
    database: node[app_name]["database"]
  })
end


directory "/home/#{account}/.bundle" do
  owner account
  group account
  mode 00755
  action :create
end

template "/home/#{account}/.bundle/config" do
  source "bundle/config.erb"
  owner account
  group account
  mode 00644
end

%w{log tmp public system tmp/pids tmp/sockets}.each do |dir|
  directory "#{node[app_name]['shared_path']}/#{dir}" do
    owner node[app_name]['account']
    group node[app_name]['account']
    mode 0755
  end
end



link "/home/#{account}/#{app_name}" do
  to node[app_name]['deploy_path']
  owner node[app_name]['account']
  group node[app_name]['account']
end