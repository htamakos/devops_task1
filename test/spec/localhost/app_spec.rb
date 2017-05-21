require 'spec_helper'
set :docker_container, 'test_docker_container'

describe command('java -version') do
  its(:stderr) { should match /1.7.0/ }
end

describe service('tomcat') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end
