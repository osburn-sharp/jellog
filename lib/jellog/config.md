# Jellog::Config Parameters

The following parameters are defined in {Jellog::Config} and should be used
in a configuration file. A default config file can be generated using:

    jeckyl config /path/to/my/config.rb

## Parameters

 * **log_reset**
 
    Reset the logfile when starting logging by setting to true, otherwise append to
    existing log

    Default: false

 * **log_level**
 
    Controls the amount of logging done by Jellog
    
     * :system - standard message, plus log to syslog
     * :verbose - more generous logging to help resolve problems
     * :debug - usually used only for resolving problems during development
    

    Default: :system

 * **disable_syslog**
 
    Set to true to prevent system log calls from logging to syslog as well

    Default: false

 * **log_mark**
 
    Set the string to be used for marking the log with logger.mark

    Default: "   ===== Mark ====="

 * **log_date_time_format**
 
    Format string for time stamps. Needs to be a string that is recognised by String#strftime
    Any characters not recognised by strftime will be printed verbatim, which may not be what you want

    Default: "%Y-%m-%d %H:%M:%S"

 * **log_rotation**
 
    Number of log files to retain at any time, between 0 and 20

    Default: 2

 * **log_length**
 
    Size of a log file (in MB) before switching to the next log, upto 20 MB

    Default: 1

 * **log_dir**
 
    Path to an existing directory where Jellog will save log files.

    Default: "/var/log/jermine"

 * **log_coloured**
 
    Set to false to suppress colourful logging. Default colours can be changed by calling
    #colours= method

    Default: true

 * **log_sync**
 
    Setting to true (the default) will flush log messages immediately, which is useful if you
    need to monitor logs dynamically

    Default: true

