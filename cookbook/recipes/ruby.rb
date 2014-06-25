include_recipe "yum-gina"

package "gina-ruby-19" do
  action :install
end

node.override['chruby']['default'] = 'ruby-1.9.3-p484'

include_recipe "chruby"
