Chef::Resource::Template.send(:include, Puffin::Sidekiq)
app_name = 'puffin'

account = node['puffin']['account']

include_recipe 'puffin::application'
include_recipe 'yum-repoforge'

%w{gina-ffmpeg mencoder}.each do |pkg|
  package pkg
end


template "#{node['puffin']['paths']['shared']}/config/initializers/sidekiq.rb" do
	owner account
	group account
	mode 00644
	variables({
    redis_url: redis_url,
    redis_namespace: redis_namespace
	})
end

template "#{node['puffin']['paths']['shared']}/config/sidekiq.yml" do
  owner account
  group account
  mode 00644
  variables({
  	queues: node_sidekiq_queues,
  	config: node['puffin']['sidekiq']['config']
  })
end

template "/etc/init.d/sidekiq_feeder" do
  source "sidekiq_init.erb"
  action :create
  mode 00755
  variables({
    user: node['puffin']['account'],
    install_path: node['puffin']['paths']['deploy']
  })
end

node[app_name]['sidekiq']['mounts'].each do |name, mnt|
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

service "sidekiq_feeder" do
  action :enable
end
