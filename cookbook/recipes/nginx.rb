app_name = "puffin"
node.override['nginx']['default_site_enabled'] = false
node.override['nginx']['repo_source'] = 'nginx'
include_recipe 'nginx'

proxies = search(:node, 'role:haproxy').collect{|n| n['ipaddress'] }

template "/etc/nginx/sites-available/#{app_name}_site" do
  source 'nginx_site.erb'
  variables({
    install_path: node[app_name]['deploy_path'],
    shared_path: node[app_name]['shared_path'],
    name: app_name,
    user: node[app_name]['account'],
    proxies: proxies
  })
end

nginx_site "#{app_name}_site"
