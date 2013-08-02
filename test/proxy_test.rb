#
#
# = Test Stdout
#
# == SubTitle
#
# Author:: Robert Sharp
# Copyright:: Copyright (c) 2013 Robert Sharp
# License:: Open Software Licence v3.0
#
# This software is licensed for use under the Open Software Licence v. 3.0
# The terms of this licence can be found at http://www.opensource.org/licenses/osl-3.0.php
# and in the file copyright.txt. Under the terms of this licence, all derivative works
# must themselves be licensed under the Open Software Licence v. 3.0
#
# 
#

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'jellog/proxy'

logger = Jellog::ProxyLogger.new('tester', :log_coloured=>true, :log_level=>:debug)

logger.system "System Message"
logger.info "Information Message"
logger.verbose "Verbose Message"
logger.debug "Debug Message"
logger.warn "Warning Message"
logger.error "Error Message"
logger.fatal "Fatal Message"

begin
  raise ArgumentError, "Wrong argument"
rescue Exception => e
  logger.exception(e)
end

logger.puts "A plain old bit of text to finish"
logger.mark

logger = Jellog::ProxyLogger.new('tester', :log_coloured=>true, :log_level=>:debug, :suppress=>true)

logger.system "System Message"
logger.info "Information Message"
logger.verbose "Verbose Message"
logger.debug "Debug Message"
logger.warn "Warning Message"
logger.error "Error Message"
logger.fatal "Fatal Message"

begin
  raise ArgumentError, "Wrong argument"
rescue Exception => e
  logger.exception(e)
end

logger.puts "A plain old bit of text to finish"
