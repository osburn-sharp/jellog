#
#
# = Jellog Stdout Logger
#
# == Looks like Jellog but outputs to stdout
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
require 'jellog'

module Jellog
  
  # A proxy for a conventional logger that outputs
  # everything to stdout/stderr
  #
  class ProxyLogger < Jellog::Logger
    
    # create a proxy logger
    #
    # can be used instead of {Jellog::Logger} to output logs to the
    # display
    #
    # @params [String] appname to display in the log
    # @params [Hash] log_opts hash of options
    # @option [Symbol] :log_level to log to (:system, :verbose, :debug)
    # @option [Boolean] :log_coloured
    # @option [Boolean] :suppress messages unless warn, error or fatal
    # @return [Jellog::ProxyLogger] self
    def initialize(appname, log_opts={})
      
      @appname = appname
      #@log_opts = LogOpts.merge(log_opts)
      
      @log_level = log_opts.delete(:log_level) || :system
      @mark = log_opts[:log_mark] || ' *** MARK ***'
      
      @logger = Jellog::Plogger.new(appname, log_opts[:log_coloured], log_opts[:suppress])
      
    end
    
  end
  
  # internal logger used by the proxy to send everything to stderr
  class Plogger < Jellog::Slogger
    
    # create a proxy output logger using stderr
    #
    # @params [String] appname to display in the log
    # @params [Boolean] coloured or not
    # @return [Jellog::Plogger] self
    def initialize(appname, coloured, suppress)
      # don't need a time stamp, so use the format string to prefix the appname
      @format_str = appname
      @coloured = coloured
      @suppress = suppress
      @colours = Levels
      @logger = $stderr
    end
    
    # when suppress is enabled, ignore messages that are suppressed
    def method_missing(meth, msg)
      
      return if @suppress && suppressed_msgs.include?(meth)
      
      super(meth, msg)
      
    end
    
    # defines suppressed messages
    def suppressed_msgs
      [:system, :info, :verbose, :debug]
    end
    
    # ensure a user does not accidentally close stderr
    def close
      # do nothing
    end
    
  end
  
end