# JELLOG

### (a.k.a. Jumpin Ermin's Loquatious Logger)

Based on the standard ruby logger, Jellog provides a slightly simplified interface and
adds a few features that may be useful:

* the ability to log to syslog for certain messages, which can be disabled during 
  setup;
* formats its own timestamp to avoid other software from interferring under the bonnet;
* colourises logs;
* provides a 'puts' method to enable apps to output to either console or log (e.g foreground
  vs background);
* returns logged messages, e.g. to cascade into exceptions
* simple log level control.

## Installation

Distributed as a gem:

    gem install jellog
  
Jellog comes with a single command: jellog, that provides access to the README file in the gem.

Jellog can also be downloaded from [GitHub](https://github.com/osburn-sharp/jellog).

## Getting Started

A simple example:

    require 'jellog'
    @logger = Jellog::Logger.new(name, params)
    begin
      @logger.system("This is a system message and will be logged to syslog")
      @logger.info("Just logged to local log")
      @logger.warn("As above")
      @logger.mark
      @logger.error("As above")
      @logger.fatal("Logged to syslog and prefixed with 'Jellog Alert:'")
      @logger.verbose("Logged locally if log_level = :verbose or :debug")
      @logger.debug("Logged locally if log_level = :debug")
      # when things go wrong
    rescue => err
      @logger.exception(err) # logs the entire backtrace in colour
    ensure
      @logger.close
    end

This creates a jellog logger and logs a variety of messages before closing it. The parameters required 
are defined in {Jellog::Config}, which is a subclass of Jeckyl::Config, (see [Jeckyl on GitHub](https://github.com/osburn-sharp/jeckyl) 
for more details):

    require 'jellog/config'
    options = Jellog::Config.new('path/to/config.rb')
    @logger = Jellog::Logger.new('MyLogger', options)

Check out {Jellog::Config} for details about the logging parameters available for Jellog.

In addition to these conventional uses, Jellog provides the following to tailor the log:

    logger = Jellog::Logger.new(name, options)
    logger.colours = colour_hash
    logger.log_level = :debug

The colour_hash is a hash of :method => :colour (e.g. :fatal=>:blue) where colours are as defined
in term_ansicolor. There are three log levels:

* :system - basic logging required for normal applications
* :verbose - additional logging that should help trouble-shooting during roll-out etc
* :debug - lots of logging for development and testing purposes

The {Jellog::Logger#warn warning}, {Jellog::Logger#error error} and {Jellog::Logger#fatal fatal} logging methods all return the message as
a string to make it convenient to cascade logging with exception raising:

    raise MyError, @logger.error("You did something stupid")
    
The {Jellog::Logger#mark mark} method simply puts a mark in the log, which can be set by one of the options. 

There is also a {Jellog::Logger#puts puts} method that allows you to arrange output either to a standard out/error/file or a log
if required. This allows parts of your code to be agnostic about where messages go, e.g. in cases where you may or may not
daemonize a task.

When using the logger as part of a service (or any other application), it may be useful to extract the parameters that are specific
to the logger only. Check out the Jeckyl class method #intersection to get these options:

    log_opts = Jellog::Config.intersection(full_opts)
    nonlog_opts = full_opts.complement(log_opts)
    
More details of Jeckyl can be found on [GitHub](https://github.com/osburn-sharp/jeckyl).
    
## Code Walkthrough

The {Jellog::Logger} presents a public interface with a range of logging methods and fairly simple customising options. It does
not do any logging itself, but creates an instance of {Jellog::Slogger} that is a simple wrapper around the standard ruby logger
but uses its own timestamps to defeat any other part of an application from fiddling with these settings: the standard logger
time stamp format is defined in a global variable and other users can change it with impunity.

This all seems a little complicated and I suspect it may be historical, the ruby logger being wrapped in Slogger to avoid
naming conflicts with Jellog::logger. The little bit of meta-magic used in Slogger, however, makes controlling attributes such
as colour and timestamps relatively compact while preserving an easy-to-read, non-magical user interface.

## Dependencies

See {file:Gemfile} for gem dependencies.

## Documentation

You can read this README file with 'jellog readme', but then as you are reading it you may already know this.

Use YARD to read the full documentation, which is available online at [RubyDoc.info](http://rdoc.info/github/osburn-sharp/jellog/frames)

## Testing/Modifying

Download Jellog from [GitHub](https://github.com/osburn-sharp/jellog) for testing. There is an rspec test that covers most of the functionality:

    rspec spec/jellog_spec.rb # tests the main functions
    rspec spec/jellog_logger_spec.rb # tests colours (manually) and support
    rspec spec/slogger_spec.rb # manual check of underlying logger
    
The last two tests don't really use rspec but generate logs in ./test and ./log which can be checked manually.

## Bugs and Issues

Details of any unresolved bugs are in {file:Bugs.rdoc}.
Issues and change requests can be posted through [GitHub](https://github.com/osburn-sharp/jellog/issues).

## Changelog

This can be found in the {file:History.txt} file. This file is used by Jevoom to manage the
version info and create git commits.

## Author and Contact

I am Robert Sharp and you can contact me on [GitHub](http://github.com/osburn-sharp)

## Copyright and Licence

Copyright (c) 2011-2012 Robert Sharp. 

See {file:LICENCE.rdoc LICENCE} for details of the licence under which Jeckyl is released.

## Warranty

This software is provided "as is" and without any express or implied
warranties, including, without limitation, the implied warranties of
merchantibility and fitness for a particular purpose.