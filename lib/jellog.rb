#
# = JELLY
#
# == Jumpin' Ermin's Loquatious Logging interface
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
# A simple logger that can log to syslog and to a log file
#
#
require 'logger'
require 'syslog'

require 'jellog/logger'

# = JELLY
#
# == Jumpin' Ermin's Loquatious Logging interface
#
# creates a logger object similar to the standard logger but one that can also
# log certain messages to syslog.
#
# To use, create an instance of Jellog and then log messages using the logging methods
# below.
#
# Jellog deals with lower level messages differently. There are three logging states:
#
# * system - log system, info, and warn or higher messages
# * verbose - also log verbose messages
# * debug - also log debug messages
#
# By default, logger instances will also log system and fatal messages to syslog.
# To disable syslog, call Jellog.disable_syslog BEFORE creating the logger.
#
# Logged messages will be placed in the logdir provided with the name appname.log
#
module Jellog

  # == The Jellog logger
  #
  # Create instances of Jellog::Logger and use then to produce colourful and useful logs.
  # See {file:README.md The Readme File} for more details.
  # 
  class Logger
  
    # selects whether or not to bother with syslog.
    # @deprecated use :disable_syslog parameter
    @@syslog = true

    # disable logging to syslog. Only works if called before creating a logger
    # @deprecated Use :disable_syslog parameter instead
    def self.disable_syslog
      @@syslog = false
    end
    
    # extract options from a hash that relate to logging, deleting from the given hash
    # and returning a hash containing just the logging options
    #
    # @deprecated use jeckyl's intersection to get logopts and complement to remove them
    #
    def self.get_options(opts, delete=false)
      log_opts = Hash.new
      LogOpts.each_key do |key|
        if opts.has_key?(key) then
          log_opts[key] = opts[key]
          opts.delete(key) if delete
        end
      end
      return log_opts
    end

    # create a new logger that logs to a file in the given log directory
    #
    # @param [String] appname name to describe application. This will be used to 
    #  name the log, and must therefore be compatible with filenaming conventions
    # @param [Hash] log_options various parameters as defined by the {Jellog::Config}
    #   class.
    #
    def initialize(appname, log_opts={})
      @appname = appname
      #@log_opts = LogOpts.merge(log_opts)
      
      logdir = log_opts.delete(:log_dir)
      @log_level = log_opts.delete(:log_level)
      @mark = log_opts[:log_mark] || ' *** MARK ***'
      
      @logfilename = File.join(logdir, "#{@appname.downcase}.log")
      # make sure we can log somewhere!
      if  !(FileTest.directory?(logdir) && FileTest.writable?(logdir)) then
        @logfilename = File.join("/tmp", "#{@appname.downcase}.log")
      elsif (FileTest.exists?(@logfilename) && ! FileTest.writable?(@logfilename)) then
        stamp = Time.now.strftime("%Y%m%d%H%M%S")
        @logfilename = File.join(logdir, "#{@appname.downcase}_#{stamp}.log")
      end
      @logger = Jellog::Slogger.new(@logfilename, 
                                  log_opts[:log_reset], 
                                  log_opts[:log_rotation], 
                                  log_opts[:log_length],
                                  log_opts[:log_coloured],
                                  log_opts[:log_date_time_format],
                                  log_opts[:log_sync])
      if log_opts[:disable_syslog] then
        @syslog = false
      else
        @syslog = @@syslog
      end
    end
  
    # get the name of the logfile as it was eventually set
    attr_reader :logfilename
    
    # set the colours to use
    #
    # @param [Hash<Symbol, Symbol>] new_colours hash to map logging methods
    #  to colours
    #
    # For example:
    #    @logger.colours = {:system => :blue}
    #
    # Note that :fatal and :mark messages are always displayed in bold as well.
    def colours=(new_colours)
      @logger.colours = new_colours
    end
  
    # set the level at which logging will work
    # should be one of:
    #
    # @param [Symbol] level to set logging to
    #
    # Symbols can be one of:
    # * :system - only system calls (or warn etc) will be logged
    # * :verbose - add verbose messages
    # * :debug - add debug messages as well
    #
    # If anything else is passed in then the default :system is used
    #
    def log_level=(level)
      case level
      when :system, :verbose, :debug
        @log_level = level
      else
        @log_level = :system
      end
    end
    
    # show current log level
    attr_reader :log_level
  
    # create a system message
    #
    # logs to syslog unless Jellog.disable_syslog was called before the logger was created
    # logs to logfile
    #
    # should be used for important info messages, such as logging successful startup etc
    #
    # @param [String] message the message to log
    def system(message)
      if @syslog then
        Syslog.open(@appname)
        Syslog.info(message)
        Syslog.close
      end
      @logger.system(message)
    end
  
    # just logs to log file - should be used for routine information that is always logged
    # but does not need to clog up the system log
    #
    # @param [String] message the message to log
    def info(message)
      @logger.info(message)
    end
  
    # logs to log file if log_level is :verbose or :debug
    # use it to output more detail about the program without going crazy
    #
    # @param [String] message the message to log
    def verbose(message)
      return true unless @log_level == :verbose || @log_level == :debug
      @logger.info(message)
    end
  
    # logs to log file if log_level is :debug
    # use it to log anything and everything, but probably not intended to survive into
    # production unless the application is unstable
    #
    # @param [String] message the message to log
    def debug(message)
      return true unless @log_level == :debug
      @logger.debug(message)    
    end
  
    # output a standard warning message to the log
    #
    # @param [String] message the message to log
    # @return [String] the message logged
    def warn(message)
      @logger.warn(message)
      return message
    end
  
    # output a standard error message to the log
    #
    # @param [String] message the message to log
    # @return [String] the message logged
    def error(message)
      @logger.error(message)
      return message
    end
  
    # output details of an exception to the log, i.e. the backtrace
    #
    # @param [Exception] err to log and backtrace
    def exception(err)
      @logger.error("#{err.class.to_s}: #{err.message}")
      err.backtrace.each do |trace|
        @logger.error(trace)
      end
    end
  
    # output a fatal error message
    # this also logs to syslog cos its likely to be important
    # unless the syslog has been disabled (see above)
    #
    # Note that the syslog message given is prefixed with "Jellog Alert:"
    # This is to make it easier to filter these messages, e.g. to create an email
    #
    # @param [String] message the message to log
    # @return [String] the message logged
    def fatal(message)
      if @syslog then
        alert = "Jellog Alert: " + message
        Syslog.open(@appname)
        Syslog.info(alert)
        Syslog.close
      end
      @logger.fatal(message)
      return message
    end
  
    # puts allows jellog to be used instead of a normal file for situations
    # where output could be to stdout or a log
    #
    # @param [String] message the message to log
    def puts(message)
      self.verbose(message)
    end
    
    # mark the log with a clear divider
    def mark
      @logger.mark(@mark)
    end
  
    # close and flush the log
    def close
      @logger.close
    end
    
    private
    
    # @deprecated - no longer required
    LogOpts = {
        :log_dir => '/tmp',
        :log_reset => false,
        :log_rotation => 2,
        :log_length => 1000 * 1000,
        :log_coloured => true,
        :log_date_time_format => "%Y-%m-%d %H:%M:%S",
        :log_sync => true,
        :log_level => :system
      }
  
  end

end