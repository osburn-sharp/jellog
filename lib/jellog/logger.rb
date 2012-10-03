#
#
# = Logger
#
# == Wrapper class to format log messages
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
# Simple wrapper around the standard logger that formats the message.
#
# Why use the standard logger at all? Mainly to handle the log rotation - if indeed it does that.
#

require 'logger'
require 'colored'

module Jellog
  
  # This inner logger is used by Jellog to encapsulate the ruby logger.
  #
  # NOTE it uses a tiny touch of meta-magic to inherit all of the logging
  # methods from Jellog and then uses a very basic interface to the logger
  # itself to protect it from other apps
  class Slogger
    
    # create a new logger with the given filename and following parameters. Note that
    # there are no defaults. It is expected that these values will be set by {Jellog::Config}
    # 
    # @param [String] logfilename path to log file to create
    # @param [Boolean] reset the log when opening, deleting any previous content
    # @param [Integer] max_logs number of log files to maintain
    # @param [Integer] max-size in megabytes being the max length of log file
    # @param [Boolean] coloured colour logs or not
    # @param [String] format - strftime format for time stamps
    # @param [Boolean] sync - flag to sync the logfile or not
    #
    def initialize(logfilename, reset, max_logs, max_size, coloured, format, sync)
      file_mode = reset ? "w" : "a"
      @logfile = File.open(logfilename, file_mode)
      @logfile.sync = sync
      @logger = ::Logger.new(@logfile, max_logs, max_size)
      @format_str = format || "%Y-%m-%d %H:%M:%S"
      @coloured = coloured
      @colours =  Levels
    end
    
    # change the colour lookup. See {Jellog::Logger} for details
    #
    # @param [Hash] colour_hash - maps logging methods to colours
    def colours=(colour_hash)
      @colours = Levels.merge(colour_hash)
    end
    
    # close the log file
    def close
      @logfile.close
    end
    
    # handle logging methods as required
    def method_missing(meth, msg)
      raise NoMethodError unless @colours.has_key?(meth)
      #meth = :info if meth == :system
      tstamp = Time.now.strftime(@format_str)
      prefix = "[#{tstamp}] #{meth.to_s.upcase}"
      prefix = prefix.send(@colours[meth]) if @coloured
      prefix = prefix.send(:bold) if @coloured && (meth == :fatal || meth == :mark)
      @logger << prefix + " - #{msg}\n"
    end
    
    private
    
    # Default colour table
    Levels = {:system=>:cyan, :info=>:white, :debug=>:green, :warn=>:yellow, :error=>:red, :fatal=>:red, :mark=>:white}
    
  end # class
  
end # module