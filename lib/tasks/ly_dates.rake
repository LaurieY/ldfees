namespace :ly do
  desc "Update start and end dates in feefiles"
  task :update_dates => :environment do
    include FeefilesHelper
  feefiles = Feefile.find(:all)
  feefiles.each do |feefile|
    feedates =get_feefile_daterange(feefile.feefilename)
    feefile.startdate = Date.strptime(feedates[0],'%d/%m/%Y')
    puts "File #{feefile.feefilename} startdate #{feedates[0]}  ->  #{feefile.startdate}/n"
    feefile.enddate = Date.strptime(feedates[1],'%d/%m/%Y')
    feefile.save
    end
  end
  end
  