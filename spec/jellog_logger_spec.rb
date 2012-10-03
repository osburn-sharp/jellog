#
# Author:: R.J.Sharp
# Email:: robert(a)osburn-sharp.ath.cx
# Copyright:: Copyright (c) 2011 
# License:: Open Software Licence v3.0
#
# This software is licensed for use under the Open Software Licence v. 3.0
# The terms of this licence can be found at http://www.opensource.org/licenses/osl-3.0.php
# and in the file LICENCE. Under the terms of this licence, all derivative works
# must themselves be licensed under the Open Software Licence v. 3.0
#
# 
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
#require 'jellog/logger'

# most of these tests require you to check the log file

describe 'Logger' do
  
  before(:each) do
    @opts = Hash.new
  end


  it "should run as expected" do
    @opts[:log_dir] = File.expand_path(File.dirname(__FILE__) + '/../test/')
    @opts[:log_reset] = true
    @opts[:log_level] = :debug
    @logger = Jellog::Logger.new('jellogtest', @opts)
    @logger.info "Hello"
    @logger.debug "This should be green"
    @logger.warn "This should be yellow"
    @logger.error "This should be red"
    @logger.fatal "This should be red and bold"
    @logger.system "This should be blue"
  end

  it "should run as ignore colours" do
    @opts[:log_dir] = File.expand_path(File.dirname(__FILE__) + '/../test/')
    @opts[:log_reset] = true
    @opts[:log_level] = :debug
    @opts[:log_coloured] = false
    @logger = Jellog::Logger.new('jellogtest1', @opts)
    @logger.info "Hello"
    @logger.debug "This should be white"
    @logger.warn "This should be white"
    @logger.error "This should be white"
    @logger.fatal "This should be white"
    @logger.system "This should be white"
  end

  it "should be possible to change colours" do
    @opts[:log_dir] = File.expand_path(File.dirname(__FILE__) + '/../test/')
    @opts[:log_reset] = true
    @opts[:log_level] = :debug
    @logger = Jellog::Logger.new('jellogtest2', @opts)
    @logger.colours = {:debug=>:red, :system=>:green}
    @logger.info "Hello"
    @logger.debug "This should be red"
    @logger.warn "This should be yellow"
    @logger.error "This should be red"
    @logger.fatal "This should be red and bold"
    @logger.system "This should be green"
  end
  
  it "should be possible to get options from a lot of others" do
    @opts[:log_dir] = File.expand_path(File.dirname(__FILE__) + '/../test/')
    @opts[:log_reset] = true
    @opts[:log_level] = :debug
    @opts[:my_stuff] = "strings"
    @opts[:more] = false
    log_opts = Jellog::Logger.get_options(@opts, true)
    log_opts.has_key?(:log_dir).should be_true
    @opts.has_key?(:log_dir).should be_false
    log_opts.has_key?(:my_stuff).should be_false
    @opts.has_key?(:my_stuff).should be_true
    #puts log_opts.inspect
    #puts @opts.inspect
  end

end
