require 'rubygems'

require 'spreadsheet'
class Hash
def self.create(keys, values)
self[*keys.zip(values).flatten]
end
end

xrefFileName = "uploads/xref4.xls"
bookx = Spreadsheet.open xrefFileName
  keys= ["santiagoref", "property","ocm4digitcode", "ocmref" ]

sheetx=bookx.worksheet 0
hXref= Hash.new()
sheetx.each do  |row|
hXref=Hash.create(keys,row)
#hXref[row[0].to_i]=Array.[](row[1],row[2].to_i,row[3].to_i)
Xref.create hXref
end
Xref.finds_all
