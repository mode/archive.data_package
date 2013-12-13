require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'rubygems'
require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  add_filter "/spec"
end

require 'tmpdir'
require 'data_package'

RSpec.configure do |config|
  def base_path
    File.join(File.dirname(__FILE__), '..', 'fixtures')
  end
end