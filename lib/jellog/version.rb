# Created by Jevoom
#
# 21-Sep-2012
#   Renamed because jelly was already in use in Gem-space.
#   [jelly-1.0.10 21-Sep-2012]
#   Tidy up documentation and tests ready for pushing to RubyGems.
#   [jelly-1.0.9 25-Jul-2012]
#   Set a default format string when none is provided
#   [jelly-1.0.8 25-Jul-2012]
#   Fix a couple of small errors in config
#   [jelly-1.0.7 23-Jul-2012]
#   Include config class for services etc that use Jelly
#   [jelly-1.0.6 12-Jun-2012]
#   Added mark method to highlight a new section in the log
#   [jelly-1.0.5 21-Jan-2012]
#   Tidy up README and correct rspec tests
#   jelly-1.0.4 10-Jan-2012
#   Change get_options to make deletion an option and not delete keys by default
#   jelly-1.0.3 09-Sep-2011
#   Change option names to comply with existing configure files.
#   jelly-1.0.2 09-Sep-2011
#   Fix close, which had not been updated to the new structure.
#   jelly-1.0.1 07-Sep-2011
#   Add get_opts class method to help pick out log-related options
#   jelly-1.0.0 06-Sep-2011
#   Introduce independent formatting and colour by option.
#   Tidy up logging options (making this incompatible with previous versions).
#   Make jelly into a local gem.
#   jelly-0.0.10 28-Aug-2011
#   Return message from error level calls to assist in keeping callers DRY
#   jelly-0.0.0 29-May-2011
#   Application generated.

module Jellog
  # version set to 1.0.11
  Version = '1.0.11'
  # date set to 21-Sep-2012
  Version_Date = '21-Sep-2012'
  #ident string set to: jellog-1.0.11 21-Sep-2012
  Ident = 'jellog-1.0.11 21-Sep-2012'
end
