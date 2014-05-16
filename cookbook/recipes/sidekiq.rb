Chef::Resource::Template.send(:include, Puffin::Sidekiq)

account = node['puffin']['account']

include_recipe 'puffin::application'
include_recipe 'yum-repoforge'

%w{gina-ffmpeg mencoder}.each do |pkg|
  package pkg
end


template "#{node['puffin']['shared_path']}/config/initializers/sidekiq.rb" do
	owner account
	group account
	mode 00644
	variables({
    redis_url: redis_url,
    redis_namespace: redis_namespace
	})
end

template "#{node['puffin']['shared_path']}/config/sidekiq.yml" do
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
    install_path: node['puffin']['deploy_path']
  })
end

node['puffin']['data'].each do |name, opts|
  directory opts['mount'] do
    action :create
  end

  mount opts['mount'] do
    device opts['host']
    fstype 'nfs'
    options 'rw'
    action [:mount, :enable]
  end
end

service "sidekiq_feeder" do 
  action :enable
end
