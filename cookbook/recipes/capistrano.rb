app_name = 'puffin'
account = node[app_name]['account']

%w{ application_path shared_path config_path initializers_path }.each do |dir|
  directory node[app_name][dir] do
    owner account
    group account
    mode 00755
    action :create
    recursive true
  end
end

%w{log tmp system tmp/pids tmp/sockets}.each do |dir|
  directory "#{node[app_name]['shared_path']}/#{dir}" do
    owner account
    group account
    mode 0755
  end
end

link "/home/webdev/#{app_name}" do
  to node[app_name]['deploy_path']
  owner account
  group account
end