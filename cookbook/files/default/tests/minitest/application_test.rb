require File.expand_path('../support/helpers', __FILE__)

describe 'puffin::application' do

  include Helpers::Puffin_cookbook

  # Example spec tests can be found at http://git.io/Fahwsw
  describe 'application' do
    it 'should create the application directory' do
      directory(node['puffin']['paths']['application']).must_exist.with(:owner, node['puffin']['account'])
      directory(node['puffin']['paths']['shared']).must_exist.with(:owner, node['puffin']['account'])
    end

    it 'should create the sunspot config' do
      file(sunspot_config_file).must_exist.with(:owner, node['puffin']['account'])
    end

    it 'should create the rails database config' do
      file(database_config_file).must_exist.with(:owner, node['puffin']['account'])
    end

    it 'should create the .bundle/config file' do
      file(bundle_config_file).must_exist.with(:owner, node['puffin']['account'])
    end

    it 'must have ruby 1.9.3p484' do
      result = assert_sh("ruby --version")
      assert_includes result, "1.9.3p484"
    end

    it 'must have bundler' do
      result = assert_sh("gem list -l bundler")
      assert_includes result, "bundler"
    end
  end
end
