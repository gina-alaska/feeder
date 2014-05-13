include_recipe 'yum-epel'
include_recipe 'yum-gina'

node['puffin']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end