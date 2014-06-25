include_recipe 'puffin::packages'
include_recipe 'puffin::ruby'
include_recipe 'puffin::_database_common'
include_recipe 'postgresql::client'
include_recipe 'build-essential'

directory "/www"

app_name = "puffin"
account = node[app_name]['account']

service 'rpcbind' do
  action [:enable, :start]
end

node[app_name]['paths'].each do |name, path|
  directory path do
    owner account
    group account
    mode 00755
    action :create
    recursive true
  end
end

node[app_name]['mounts'].each do |name, mnt|
  directory mnt['mount_point'] do
    recursive true
  end
  mount mnt['mount_point'] do
    device mnt['device']
    fstype mnt['fstype'] if mnt['fstype']
    options mnt['options'] if mnt['options']
    action mnt['action']
  end
end

node[app_name]['links'].each do |name, lnk|
  link lnk['name'] do
    to lnk['to']
    owner account
    group account
    action lnk['action']
  end
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

include_recipe "puffin::_bundler"

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
