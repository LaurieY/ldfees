len=2
require 'rubygems'
require 'logging'
   log = Logging.logger('example from run_fees2.0.rb')
  
      log.add_appenders(
        Logging.appenders.stdout,
        Logging.appenders.file('run_fees.log')
    )
    log.level = :debug

    log.debug Time.now.strftime("%d/%m/%Y %H:%M")
   #  log.debug  "ready to start fees13"
   require 'optparse'
  # require '/home/lyatesco/ldfees31/uploads/fees1.9.rb'
   require File.expand_path(File.join(File.dirname(__FILE__),'fees14.rb'))
  log.debug  "have required  fees14"
LDfees.main(ARGV)
log.debug Time.now.strftime("%d/%m/%Y %H:%M")
  log.debug  "returned from fees14"