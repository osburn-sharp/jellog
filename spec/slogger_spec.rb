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
require 'jellog/logger'

#
# Not a proper test - check the log file manually
#

describe 'Slogger' do
  
  before(:each) do
    @logfile = File.expand_path(File.dirname(__FILE__) + '/../test/log_file.log')
  end


  it "should run as expected" do
    @logger = Jellog::Slogger.new(@logfile, true, 1, 100000, true, "%Y-%m-%d %H:%M:%S", true)
    @logger.info "Hello"
    @logger.debug "This should be green"
    @logger.warn "This should be yellow"
    @logger.error "This should be red"
    @logger.fatal "This should be red and bold"
    @logger.system "This should be blue"
    @logger.mark " ==========This is a mark============="
  end

end
