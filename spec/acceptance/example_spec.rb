require 'spec_helper'

describe "ignore" do

  example "ignore" do
    hosts.each do |host|
      on host, 'echo hello'
    end
  end

  example "use self.host" do
    self.hosts = hosts
  end

  example "use DSL method" do
    echo_on hosts, 'Hello World!'
  end

  example "access the logger" do
     logger.debug("hi, i'm a debug message")
     logger.notify("hi, I'm a notify message")
  end

  example "access the options" do
    expect(options).to be_kind_of(Hash)
  end

  example "create a beaker dsl::step" do
    step('testing that a step can be used')
  end

  context "has serverspec support" do
    hosts.each do |node|
      sshd = case node['platform']
             when /windows|el-|redhat|centos/
               'sshd'
             else
               'ssh'
             end
      describe service(sshd), :node => node do
        it { should be_running }
      end

      usr = case node['platform']
            when /windows/
              'Administrator'
            else
              'root'
            end
      describe user(usr), :node => node do
         it { should exist }
      end
    end
  end

  context "serverspec: can access default node" do
    usr = case default['platform']
          when /windows/
            'Administrator'
          else
            'root'
          end
    describe user(usr) do
       it { should exist }
    end
  end

  context "serverspec: can match multiline file to multiline contents" do
    contents = "four = five\n[one]\ntwo = three"
    create_remote_file(default, "file_with_contents.txt", contents)
    describe file("file_with_contents.txt") do
      it { should be_file }
      it { should contain(contents) }
    end
  end
end
