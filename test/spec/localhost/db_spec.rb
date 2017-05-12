require 'spec_helper'
set :docker_container, 'test_docker_container'

describe package('mysql-community-server') do
  it { should be_installed }
end

describe package('mysql-community-client') do
  it { should be_installed }
end

describe package('mysql-community-common') do
  it { should be_installed }
end

describe package('mysql-community-libs') do
  it { should be_installed }
end

describe package('mysql-community-libs-compat') do
  it { should be_installed }
end

describe port('3306') do
  it { should be_listening }
end

describe 'MySQL config parameters' do
  context mysql_config('character-set-server') do
    its(:value) { should eq 'utf8' }
  end

  context mysql_config('slow-query-log') do
    its(:value) { should eq 'TRUE' }
  end

  context mysql_config('socket') do
    its(:value) { should eq '/var/lib/mysql/mysql.sock' }
  end

  context mysql_config('max-connections') do
    its(:value) { should eq 100 }
  end
end