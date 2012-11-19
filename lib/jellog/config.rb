#
#
# = Jelloga
#
# == configuration config parameters for Jellog
#
# Author:: Robert Sharp
# Copyright:: Copyright (c) 2012 Robert Sharp
# License:: Open Software Licence v3.0
#
# This software is licensed for use under the Open Software Licence v. 3.0
# The terms of this licence can be found at http://www.opensource.org/licenses/osl-3.0.php
# and in the file copyright.txt. Under the terms of this licence, all derivative works
# must themselves be licensed under the Open Software Licence v. 3.0
#
# 
#
require 'jeckyl'

module Jellog
  
  # This class defines the parameters that the {Jellog::Logger} expects when creating an instance.
  # You can inherit from this class to include these parameters automatically in
  # your own config class, e.g. for an application that uses Jellog:
  #
  # For example:
  #
  #    module MyApplication
  #      class Config < Jellog::Options
  #        # define your parameter methods here
  #      end
  #    end
  #
  # @see file:lib/jellog/config.md Jellog Parameter Descriptions
  #
  class Config < Jeckyl::Config
    
    def configure_log_dir(dir)
      default '/var/log/jerbil'
      comment "Path to a writeable directory where Jellog will save log files."

      a_writable_dir(dir)
    end



    def configure_log_level(lvl)
      default :system
      comment "Controls the amount of logging done by Jellog",
        "",
        " * :system - standard message, plus log to syslog",
        " * :verbose - more generous logging to help resolve problems",
        " * :debug - usually used only for resolving problems during development",
        ""

      lvl_set = [:system, :verbose, :debug]
      a_member_of(lvl, lvl_set)

    end



    def configure_log_rotation(int)
      default 2
      comment "Number of log files to retain at any time, between 0 and 20"

      a_type_of(int, Integer) && in_range(int, 0, 20)

    end



    def configure_log_length(int)
      default 1 #Mbyte
      comment "Size of a log file (in MB) before switching to the next log, upto 20 MB"

      a_type_of(int, Integer) && in_range(int, 1, 20)
      int * 1024 * 1024
    end 
    



    def configure_log_reset(bool)
      default false
      comment "Reset the logfile when starting logging by setting to true, otherwise append to",
        "existing log"
      a_boolean(bool)
    end
    
    
    
    def configure_log_coloured(bool)
      default true
      comment "Set to false to suppress colourful logging. Default colours can be changed by calling",
        "#colours= method"
      a_boolean(bool)
    end
    
    
    
    def configure_log_date_time_format(format)
      default "%Y-%m-%d %H:%M:%S"
      comment "Format string for time stamps. Needs to be a string that is recognised by String#strftime",
        "Any characters not recognised by strftime will be printed verbatim, which may not be what you want"
        
      a_string(format)
    end
    
    
    
    def configure_log_sync(bool)
      default true
      comment "Setting to true (the default) will flush log messages immediately, which is useful if you",
        "need to monitor logs dynamically"
      a_boolean(bool)
    end
    
    
    
    def configure_log_mark(m_str)
      default "   ===== Mark ====="
      comment "Set the string to be used for marking the log with logger.mark"
      a_string(m_str)
    end
    
    def configure_disable_syslog(bool)
      default false
      comment "Set to true to prevent system log calls from logging to syslog as well"
      a_boolean(bool)
    end
    
  end
  
  # @deprecated Use Jellog::Config
  Options = Config
  
end