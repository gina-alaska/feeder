Chef::Resource::Template.send(:include, Puffin::Sidekiq)

account = node['puffin']['account']

include_recipe 'puffin::application'

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

service "sidekiq_feeder" do 
  action :enable
end