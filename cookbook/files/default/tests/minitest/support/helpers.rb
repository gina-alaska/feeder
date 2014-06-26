module Helpers
  module Puffin_cookbook
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def sunspot_config_file
      File.join(node['puffin']['paths']['shared'], 'config/sunspot.yml')
    end

    def database_config_file
      File.join(node['puffin']['paths']['shared'], 'config/database.yml')
    end

    def bundle_config_file
      "/home/#{node['puffin']['account']}/.bundle/config"
    end
  end
end
