#fees11.rb introduces the capability of driving it all through a default yaml file & also that the yaml file can present options
#The command line options take precedence.
#The yaml file can contain a line like
#options: -a -c -l fees.log -s <start date>
#If there are options presented they override the corresponding one in the yaml file
# Also fees11.rb alters the standard outputs to be to a log file and the stdout is more informative of the state of play

#fees10.rb, introduce capability to only output data from transactions on or after a date
# includes a function to scan input to return all the transaction dates, this can be used on web version to provide select list of dates.
# batch process has a switch -s for start date

#fees9.rb
# scan input xls files for structure, ASSUME column 0 is the date and is the property identifier, but check these also
# identify columns for concepto - conceptoCol, fee value - feeCol, payment value paymentCol

#fees8.rb
# command line options
# -y <yaml file name> default to fees.yaml
# -a, -ignore-apertura  do not include ASIENTO DE APERTURA lines
# -c, -ignore-cierre  do not include ASIENTO DE CIERRE lines
# -n, -negate-cierre  reverse the significance of ASIENTO DE CIERRE lines to negate APERTURA lines
# -s -start-date  only include transactions on or after that date

#fees7.rb identifies the closing balance for a property
# and generates a reversal to negate the opening balance in the next year 


# ********* fees6.rb, takes file names from fees.yaml file
# unless the first parameter gives the name of a yaml file

#  Uses csv for the template file
# output to csv file directly using simple IO

# Read  xref.xls into an hash
# Read template.csv into a hash
# read  Santiago file
#**************
# takes the 43000xxx ref from santiago, obtains the OCM ref from xref file
# for each date row until next property
#gets 1st 4 columns from template file for that property ref, adds date, subject,Fees and payments columns obtained from Santiago
# outputs to fees_output.csv
#require 'rubygems'
require 'spreadsheet'
require 'fastercsv'
require 'yaml'
require 'optparse'
require 'date'
require 'log4r'
include Log4r

class LDfees
def self.main (arGs)
# This hash will hold all of the options
 # parsed from the command-line by
 # OptionParser.
 @loggerf = Logger.new('fees.log')
 #logger = Log4r::Logger.new 'logger'
 #--------
 # create a logger named 'mylog' that logs to stdout
logger = Log4r::Logger.new 'mylog'

# You can use any Outputter here.
logger.outputters = Outputter.stdout

# Open a new file logger and ask him not to truncate the file before opening.
# FileOutputter.new(nameofoutputter, Hash containing(filename, trunc))
file = FileOutputter.new('fileOutputter', :filename => 'log4rout.log',:trunc => false)

# You can add as many outputters you want. You can add them using reference
# or by name specified while creating
logger.add(file)
# or mylog.add(fileOutputter) : name we have given.
#_______
 #logger.outputters = Outputter.stdout
 #file = FileOutputter.new('fileOutputter', :filename => 'log4rout.log',:trunc => false)
 #logger.add(fileOutputter)
# mylog = Log4r::Logger.new 'mylog'
#mylog.outputters = Outputter.stdout
 logger.info(" opening with args = #{arGs}")
 @loggerf.debug "arGs = #{arGs.inspect}\n\n"
 if arGs.empty? then
    arGs= getParamsFromYaml()
     @loggerf.debug "NOW arGs = #{arGs.inspect}\n\n"
 
 else
     @loggerf.debug "not empty arGs = #{arGs.inspect}\n"
 end
     

 options = {}
 
 optparse = OptionParser.new do|opts|
   # Set a banner, displayed at the top
   # of the help screen.
   opts.banner = "Usage: fees11.rb [options]"
    # Define the options, and what they do
   options[:verbose] = false
   opts.on( '-v', '--verbose', 'Output more information' ) do
      options[:verbose] = true
   end
   
   options[:ig_apertura] = false
   opts.on( '-a', '--ignore-apertura', 'Ignore ASIENTO DE APERTURA lines' ) do
      options[:ig_apertura] = true
   end
   
   options[:ig_cierre]  = false
   opts.on( '-c', '--ignore-cierre', 'Ignore ASIENTO DE CIERRE lines' ) do
      options[:ig_cierre] = true
   end
   
   options[:neg_cierre]  =false
   opts.on( '-n', '--negate-cierre', 'reverse the significance of ASIENTO DE CIERRE lines to negate APERTURA lines' ) do
      options[:neg_cierre] = true
   end
   
   
   options[:logfile] = nil
   opts.on( '-l', '--logfile FILE', 'Write log to FILE' ) do|file|
     options[:logfile] = file
   end
   
   options[:yamlfile] = "uploads/fees.yaml"
   opts.on( '-y', '--yamlfile FILE', 'use yaml from FILE' ) do|file|
     options[:yamlfile] = file
   end
   
      options[:start_date] = "01/04/2001"
   opts.on( '-s', '--start-date  DATE', 'only start at date in form dd/mm/yyyy (Santiago format)' ) do|sDate|
     options[:start_date] = sDate
   end
      # This displays the help screen, all programs are
   # assumed to have this option.
   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
    end
 end
 optparse.parse(arGs)
  #yamlFileName= "fees.yaml"
 @loggerf.debug "Being verbose" if options[:verbose]
 #puts "Being quick" if options[:quick]
 @loggerf.debug "Ignore ASIENTO DE APERTURA lines" if options[:ig_apertura]
  @loggerf.debug "Ignore ASIENTO DE CIERRE lines" if options[:ig_cierre]
   @loggerf.debug "reverse the significance of ASIENTO DE CIERRE lines" if options[:neg_cierre]
 @loggerf.debug "Logging to file #{options[:logfile]}" if options[:logfile]
 logger.info "Using yaml file #{options[:yamlfile]}" if options[:yamlfile]
 yamlFileName=options[:yamlfile]
 logger.info "start date = #{options[:start_date]} \n"
 startDate = Date.strptime(options[:start_date], "%d/%m/%Y")   #Date.parse(options[:start_date])
 #puts "Using yaml file #{yamlFileName}\n"

config = YAML.load_file(yamlFileName)
logger.debug config.inspect
templateFileName = config["template"]
outFileName = config["output"]
xrefFileName = config["xref"]
feesFileName = config["fees"]

logger.info "Template File is #{templateFileName}\n"
logger.info "Output File is #{outFileName}\n"
logger.info"xref File is #{xrefFileName}\n"
logger.info "Fees File is #{feesFileName}\n"
#******* analyse input fees file to find relevany columns
hashCols = Hash.new

LDfees.findConcepto(feesFileName,hashCols)
#puts "hashCols = #{hashCols.inspect}\n"
conceptoCol= hashCols["conceptoCol"]
feeCol= hashCols["feeCol"]
paymentCol =hashCols["paymentCol"]
@loggerf.debug "feeCol= #{feeCol}  paymentCol=#{paymentCol}  conceptoCol = #{conceptoCol}"


#*******************************************
if File.exists?(outFileName)
   File.delete(outFileName)
end
outFile = File.new(outFileName,'w+')
bookx = Spreadsheet.open xrefFileName

sheetx=bookx.worksheet 0
hXref= Hash.new()
sheetx.each do  |row|
hXref[row[0].to_i]=Array.[](row[1],row[2].to_i)

end
# puts hXref.inspect

# *********************************
#Read template.csv into a hash hTempl
#  First read it as a text file & remove the '=' at the beginning of each field
# **********************************
hTempl = Hash.new()

templFile = File.open(templateFileName)
templFile.each_line{ |line|

row = line.tr('=','').parse_csv
hTempl[row[1].to_i] = Array.[](row[0],row[2], row[3],row[4], row[5],row[6], row[7])

}
templFile.close()

templFile = File.open(templateFileName)

# ** write first 5 lines of template to output file, i.e. headers & example lines
for i in 0..4
outFile.write( templFile.readline)
end
templFile.close()


# **********************************
# read Santiago file & process to output file

# *********************************

#  puts " Test getting xref 4300001 : ", hXref[4300001][1],"\n"

# bookS = Spreadsheet.open('MAYORES EXCELL.xls')


bookS = Spreadsheet.open(feesFileName)
sheetS=bookS.worksheet 0
# @name=sheet1[10,0]
# puts sheetS.last_row_index
#puts " hXref = #{hXref.inspect}"
#puts "hTempl 6941 = #{hTempl[6941]}"
  sheetS.each { |row|
    # do something interesting with a row
if row[0].kind_of? String

 if row[0].start_with?('4300')
# ****************** Found a new property reference
# look up the entry in xref to get the OCM reference
 
#puts "row[0]  = #{row[0]} goes to #{hXref[row[0].to_i][1] } "
  @ocmRef= hXref[row[0].to_i][1]  # this is the OCM ref corresponding

  ocmEntry= hTempl[@ocmRef.to_i]
#  puts "ocmEntry= #{ocmEntry}"
  @ocmLinea= ocmEntry[0],",",@ocmRef.to_i,",",ocmEntry[1],",",ocmEntry[2],","
  @ocmLineab=""
 else

    begin
     if row[0] =~ /\d\d\/\d\d\/\d\d\d\d/  # if this field contains a valid date
   #   test if date is >= startDate  (stored as a Date  )  the default i 2001, handling no startdate specified
 #  puts "\n row 0 = #{row[0]} with class  #{row[0].class}\n"
 ####puts "Startdate = #{startDate}  this Date = #{row[0]}  , #{Date.strptime(row[0], "%d/%m/%Y")}\n"
   if not (Date.strptime(row[0], "%d/%m/%Y") - startDate ) <0 then
      myDate = row[0]  # I want the string as-is, making it a date invites a change of format
        #@loggerf.debug "AD myDate #{myDate}  AD row[0] #{Date.strptime(row[0], "%d/%m/%Y")}  AD startDate  #{startDate }\n"
# ******need to remove any commas in Santiago's Concepto field
#             puts "AE #{@ocmLinea}\n"

       concepto = row[conceptoCol].tr(',','&')
#puts " concepto #{myDate}  #{concepto}\n"
#puts "ocmLinea = #{@ocmLinea}\n"
       
#puts "#{@ocmLinea}#{myDate},#{concepto},#{row[feeCol]}"
       @ocmLineab = @ocmLinea,myDate,",",concepto,",",row[feeCol],",",row[paymentCol]
#puts "AF #{@ocmLineab} \n"
       if concepto =="ASIENTO DE CIERRE" then
         
         if options[:neg_cierre] then
           @ocmLineab = @ocmLinea,myDate, "," ,"Negation of next years ASIENTO DE APERTURA",",",row[feeCol],",",row[paymentCol]
          end
         if options[:ig_cierre] then  # ignore this line
           @ocmLineab = ""
         end
                
       end
       if concepto =="ASIENTO DE APERTURA" and options[:ig_apertura] then # ignore this line
           @ocmLineab = ""
   
         end
       
       outFile.write( "#{@ocmLineab}\n") if @ocmLineab!=""
    
     else  # of date check
     #   puts "not a date #{row[0]}\n"
        end
    end
    end  # of if startdate ok
 end
 

end
}
 logger.info " File Processing Complete"
end

def self.findColValue(feesFile,searchFor,arrayC)
  # **
  #returns array with column of the searched string and the column of the next decimal value
  #****
  bookC = Spreadsheet.open(feesFile)
  sheetC=bookC.worksheet 0
  sheetC.each { |row|
#   puts "searchFor= #{searchFor}"
# scan through the file and find a row with a date and a column containing "RECIBO DEL dd/mm/yyyy"
#return the column number within the hash sent as 2nd param
if row[0] =~ /\d\d\/\d\d\/\d\d\d\d/  then # if this field contains a valid date
  foundRow = false
  row.each_index { |col|
    if row[col]=~ searchFor then
#      puts "col=#{col} : #{row[col]} "
      foundRow = true
      arrayC[0]= col
    end # found the concept column now look for the next decimal column
#puts "A  #{row[col]}\n"
   if foundRow
#puts "B  #{row[col]}\n"
#puts "C #{row[col].class}"
     if row[col].class == Float then # found a decimal value
     @loggerf.info " found decimal value at column #{col} value #{row[col]}\n"
     arrayC[1] = col
     
     return arrayC
     
     end
    end
   }
  end
  }
end
def self.findConcepto(feesFile,hashC)
  arrayC = Array.new
findColValue(feesFile,/RECIBO DEL \d\d\/\d\d\/\d\d\d\d/,arrayC)
#  puts "arrayC = #{arrayC.inspect}\n"
hashC["conceptoCol"]= arrayC[0]
hashC["feeCol"]= arrayC[1]
findColValue(feesFile,/COBRO REC\. DEL \d\d\/\d\d\/\d\d\d\d/,arrayC)
hashC["paymentCol"]= arrayC[1]
#puts "hashC = #{hashC.inspect}\n"
return hashC
end  # of findConcepto


 
def self.getParamsFromYaml()
   config = YAML.load_file('uploads/fees.yaml')
   # make an array of options
   return  config["options"]
   end

#self.main()

end
