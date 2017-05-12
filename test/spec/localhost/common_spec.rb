require 'spec_helper'
set :docker_container, 'test_docker_container'

describe group('dba') do
  it { should exist }
end

describe user('oracle') do
  let(:authorized_key) { 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAsodnUKNxd9xwCoxh/NQkh3/mHWm+f7ymj9PMfJPyme' \
                         'Ufz46fnQJjYpNHhdqKhkrrS5fyCh/VJmdT9jvIqU5oPY6aE0z5lT3TX9lLM6qT4WUv1W0Iq5aod+V3' \
                         'JfsxoaKJ3DuC9V5jhFjnrS+gdG4Y3PRzYwCx+oW0XgAM7lMdsVRxRopmXpzKUmeUhSR6oqyNMXXiFU' \
                         'Bq6UwELubyzPkrFyryizazvXSZFCMKW+eL0BUbom3tgvGRUs/9AI6S3ckQhwwW+0BQo8+xdcfFmcrU' \
                         'baFONxhs+EdgrYL+PBaIZQ8l2GRprdxOeunIVY3dd2JB1GrC73' }
  it { should exist }
  it { should belong_to_group 'dba' }
  it { should have_home_directory '/home/oracle' }
  it { should have_login_shell '/bin/bash' }
  it { should have_authorized_key authorized_key }
  its(:encrypted_password) { should eq '$1$qQxgB.vu$Pg5.KzIJ.7AfkOmkDiGGu/' }
end

describe file('/home/oracle/.ssh') do
  it { should exist }
  it { should be_mode 700 }
  it { should be_directory }
end

describe file('/home/oracle/.ssh/authorized_keys') do
  it { should exist }
  it { should be_mode 600 }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'dba' }
end

describe file('/etc/sudoers.d') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/sudoers.d/oracle') do
  it { should exist }
  it { should be_mode 440 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/home/oracle/.bash_profile') do
  it { should exist }
  it { should be_owned_by 'oracle' }
  it { should be_grouped_into 'dba' }
end

describe command("su -l oracle -c 'echo -n $http_proxy'") do
  its(:stdout) { should eq 'http://jp-proxy.jp.oracle.com:80' }
end

describe command("su -l oracle -c 'echo -n $https_proxy'") do
  its(:stdout) { should eq 'http://jp-proxy.jp.oracle.com:80' }
end

describe command("su -l oracle -c 'echo -n $LANG'") do
  its(:stdout) { should eq 'ja_JP.utf8' }
end
