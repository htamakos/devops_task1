require 'spec_helper'
set :docker_container, 'test_docker_container'

describe command('java -version') do
  its(:stderr) { should match /1.7.0/ }
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  it { should belong_to_primary_group 'tomcat' }
  it { should have_home_directory '/usr/share/tomcat' }
end

describe file('/opt/apache-tomcat-7.0.61') do
  it { should exist }
  it { should be_directory }
end

describe file('/usr/share/tomcat') do
  it { should be_symlink }
end

describe file('/usr/share/tomcat') do
  it { should be_directory }
end

describe file('/usr/share/tomcat/conf/server.xml') do
  it { should exist }
end

describe file('/etc/init.d/tomcat') do
  it { should exist }
  it { should be_mode 755 }
end

describe service('tomcat') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8080) do
  it { should be_listening }
end
