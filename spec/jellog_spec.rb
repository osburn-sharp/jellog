#
# Author:: Robert Sharp
# Copyright:: Copyright (c) 2011 Robert Sharp
# License:: Open Software Licence v3.0
#
# This software is licensed for use under the Open Software Licence v. 3.0
# The terms of this licence can be found at http://www.opensource.org/licenses/osl-3.0.php
# and in the file copyright.txt. Under the terms of this licence, all derivative works
# must themselves be licensed under the Open Software Licence v. 3.0
#
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'syslog'
require 'jellog/config'

log_dir = File.expand_path(File.dirname(__FILE__) + '/../log')
test_dir = File.expand_path(File.dirname(__FILE__) + '/../test')

FileUtils.mkdir(log_dir) unless FileTest.directory?(log_dir)

describe "Jellog" do

  it "should create a simple log file" do
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>true) # reset the file
    logger.info("Testing the logger")
    logger.close
    File.exists?(logger.logfilename).should be_true
    logger.logfilename.should match("#{log_dir}/jellog.log")
  end

  it "should attempt to log system messages to syslog" do
    Syslog.should_receive(:info).once.and_return(true)
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.system("Testing the logger at system level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before
  end

  it "should not attempt to log system messages to syslog if disabled" do
    Syslog.should_not_receive(:info)
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false, :disable_syslog=>true)
    before = File.stat(logger.logfilename).size
    logger.system("Testing the logger at system level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before
  end

  it "should not attempt to log system messages to syslog if disabled the old way" do
    Syslog.should_not_receive(:info)
    Jellog::Logger.disable_syslog
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.system("Testing the logger at system level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before
  end

  it "should log an info message just to the logfile" do
    Syslog.should_not_receive(:info)
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.info("Testing the logger at info level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before
  end

  it "should not log a verbose or debug message by default" do
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.verbose("Testing the logger at verbose level")
    logger.debug("Testing the logger at debug level")
    logger.puts("A simple puts message")
    logger.close
    File.stat(logger.logfilename).size.should == before

  end

  it "should log a verbose message when set" do
    logger = Jellog::Logger.new("Jellog",:log_dir=>log_dir, :reset=>false)
    logger.log_level = :verbose
    before = File.stat(logger.logfilename).size
    logger.verbose("Testing the logger at verbose level")
    logger.puts("A simple puts message")
    logger.close
    File.stat(logger.logfilename).size.should_not == before

  end

  it "should not log a debug message when set to verbose" do
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false)
    logger.log_level = :verbose
    before = File.stat(logger.logfilename).size
    logger.debug("Testing the logger at verbose level")
    logger.close
    File.stat(logger.logfilename).size.should == before

  end

  it "should log a debug message when set" do
    logger = Jellog::Logger.new("Jellog",:log_dir=>log_dir, :reset=>false)
    logger.log_level = :debug
    before = File.stat(logger.logfilename).size
    logger.debug("Testing the logger at debug level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before

  end

  it "should log all other levels regardless" do
    logger = Jellog::Logger.new("Jellog",:log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.warn("Testing the logger at warn level")
    logger.error("Testing the logger at error level")
    logger.fatal("Testing the logger at fatal level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before

  end

  
  it "should not attempt to log system messages with syslog disabled" do
    Syslog.should_not_receive(:info)
    Jellog::Logger.disable_syslog
    logger = Jellog::Logger.new("Jellog", :log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.system("Testing the logger at system level")
    logger.close
    File.stat(logger.logfilename).size.should_not == before
  end

  it "should default to tmp if the logdir does not exist" do
    tmp_log = '/tmp/jellog.log'
    FileUtils.rm_f tmp_log
    logger = Jellog::Logger.new("Jellog", :log_dir=>'/never/likely/to/exist', :reset=>true)
    logger.logfilename.should == tmp_log
    logger.info "Hey"
    logger.close
    FileTest.exists?(tmp_log).should == true
  end

  it "should change log name if the log file is not writeable" do
    #stamp = Time.now.strftime("%Y%m%d%H%M%S")
    logger = Jellog::Logger.new("JellogMould",:log_dir=>log_dir, :reset=> true)
    log_name = logger.logfilename
    log_name.should match(/jellogmould_[0-9]+.log$/)
    logger.info "Hello"
    logger.close
    FileUtils.rm log_name
  end
  
  it "should mark the log" do
    logger = Jellog::Logger.new("Jellog",:log_dir=>log_dir, :reset=>false)
    before = File.stat(logger.logfilename).size
    logger.mark
    logger.close
    marker = File.readlines(logger.logfilename).last.chomp
    marker.should match(/\*\*\* MARK \*\*\*$/)
    
  end
  
  it "should mark the log with a bespoke mark" do
    logger = Jellog::Logger.new("Jellog",:log_dir=>log_dir, :reset=>false, :log_mark=> ' === MARK ===')
    before = File.stat(logger.logfilename).size
    logger.mark
    logger.close
    marker = File.readlines(logger.logfilename).last.chomp
    marker.should match(/=== MARK ===$/)
    
  end
  
  it "should be possible to configure the logger using Jellog::Config" do
    jellog_config_path = File.join(test_dir, 'conf.d', 'jellog.rb')
    jellog_conf = Jellog::Config.new(jellog_config_path)
    logger = Jellog::Logger.new("Jellog", jellog_conf)
    logger.logfilename.should == File.join(log_dir, 'jellog.log')
    logger.log_level.should == :debug
    logger.close
  end
  
  
end
