ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'
require 'sidekiq/testing'
require 'simplecov'
SimpleCov.start 'rails'

class ActiveSupport::TestCase
  fixtures :all

  # Add more helper methods to be used by all tests here...
  ::Sunspot.session = ::Sunspot::Rails::StubSessionProxy.new(::Sunspot.session)

  # Override the configuration for dragonfly to point at fixture data
  Dragonfly[:images].datastore.configure do |d|
    d.root_path = Rails.root.join('test/fixtures/images').to_s
    d.server_root = Rails.root.join('test/fixtures').to_s
  end

  def stub_dragonfly_preview(method, return_value)
    preview = Object.new
    preview.stubs(method).returns(OpenStruct.new(return_value))

    Entry.any_instance.stubs(:preview).returns(preview)
  end

end
#
class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end