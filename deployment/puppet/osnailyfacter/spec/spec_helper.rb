require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'webmock/rspec'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

PROJECT_ROOT = File.expand_path('..', File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(PROJECT_ROOT, "lib"))

# Add fixture lib dirs to LOAD_PATH. Work-around for PUP-3336
Dir["#{fixture_path}/modules/*/lib"].entries.each do |lib_dir|
  $LOAD_PATH << lib_dir
end

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.mock_with(:mocha)
  c.alias_it_should_behave_like_to :it_configures, 'configures'
end

def puppet_debug_override
  if ENV['SPEC_PUPPET_DEBUG']
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
  end
end

###
