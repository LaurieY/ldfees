class Hash
def self.create(keys, values)
self[*keys.zip(values).flatten]
end
end
class Extracted < ActiveRecord::Base
  belongs_to :feefile


  def self.insert_table(ffid)
keys= ["owner", "reference","property", "coefficient","adate","subject", "fees", "payments" ]
require 'csv'
    #require 'fastercsv'
    directory= "uploads"
    csvFile= File.join(directory,Feefile.find(ffid).extractfilename)
    puts " csvFile being used is #{csvFile}"
    
    #Ignore the 1st 5 lines as headers & template
    #for i in 0..4
    #puts tempFile.readline
    #end
    counter=1
    Extracted.transaction do
	File.open(csvFile,'r:iso-8859-1:utf-8') do |tempFile|
    #File.open(csvFile,"r",) do |tempFile|
      while (line=tempFile.gets)
        if counter >5
          vv=CSV.parse_line(line)
          hh=Hash.create(keys,vv).merge({:feefile_id=>"#{ffid}"})
            #        puts hh.inspect
             #       puts Date.strptime(hh["adate"],'%d/%m/%Y')
          hh=hh.merge({ "adate" => Date.strptime(hh["adate"],'%d/%m/%Y').to_s})
         # puts vv.inspect
         Extracted.create(hh)
        end
        counter+=1
      end
    end
    end  # of Transaction
    
  #  FasterCSV.foreach(csvFile) do |row|
  #  end
   # Extracted.create(:feefile_id=> ffid )
    
  end
end

