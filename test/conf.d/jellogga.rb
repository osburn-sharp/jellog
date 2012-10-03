project_dir = File.expand_path('../..', File.dirname(__FILE__))

#
# Configuration Options for: Jellog::Options
#

# Controls the amount of logging done by Jellog
# 
#  * :system - standard message, plus log to syslog
#  * :verbose - more generous logging to help resolve problems
#  * :debug - usually used only for resolving problems during development
# 
log_level :debug

# Set the string to be used for marking the log with logger.mark
log_mark "   === Mark ==="

# Number of log files to retain at any time, between 0 and 20
#log_rotation 2

# Location for Jellog (logging utility) to save log files
log_dir File.join(project_dir, 'log')

# Setting to true (the default) will flush log messages immediately, which is useful if you
# need to monitor logs dynamically
#log_sync true

# Reset the logfile when starting logging by setting to true, otherwise append to
# existing log
#log_reset false

# Format string for time stamps. Needs to be a string that is recognised by String.strftime
# Any characters not recognised by strftime will be printed verbatim, which may not be what you want
#log_date_time_format "%Y-%m-%d %H:%M:%S"

# Size of a log file (in MB) before switching to the next log, upto 20 MB
#log_length 1

# Set to false to suppress colourful logging. Default colours can be changed by calling
# colours= method
#log_coloured true

