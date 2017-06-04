#encoding:ISO-8859-1
require 'csv'
templateFileName = 'fees_template_sept.csv'
#customers = CSV.read('test.csv',encoding:'ISO-8859-1')
hTempl = Hash.new()

templFile = File.open(templateFileName,'r:iso-8859-1:utf-8' )  #r:iso-8859-1:utf-8  or encoding:'ISO-8859-1'
#line=templFile.readline
#puts line

templFile.each_line{ |line|
#line.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')

# if ! line.valid_encoding?
  # line = line.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
# end
rowa = line.tr('=','')
row = CSV.parse(rowa)
puts rowa
puts row
hTempl[row[1].to_i] = Array.[](row[0],row[2], row[3],row[4], row[5],row[6], row[7])

}
templFile.close()