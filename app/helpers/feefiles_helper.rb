module FeefilesHelper
  def get_feefile_daterange(name_of_feefile)
    directory= "uploads"
    path =File.join(directory,name_of_feefile)
    xlfile= Spreadsheet.open(path)
    sheetx= xlfile.worksheet 0
    aDate= Array.new
    aProp=Array.new
    sheetx.each do  |row|
      if row[0] =~ /\d\d\/\d\d\/\d\d\d\d/   then
        aDate<<Date.strptime(row[0], "%d/%m/%Y") 
      end
    end
    aDateSort = aDate.sort
    return [aDateSort.first.strftime("%d/%m/%Y"),aDateSort.last.strftime("%d/%m/%Y")]
  end
  def get_feefile_rows(name_of_feefile) #,which_page=1, lines_per_page=20 )
    directory= "uploads"
    path =File.join(directory,name_of_feefile)
    xlfile= Spreadsheet.open(path)
    sheetx= xlfile.worksheet 0
    aXLrows = Array.new
    #start_row = (which_page-1)*lines_per_page
    #end_row = (which_page*lines_per_page)-1
    #for arow in (start_row.. end_row)
    #  aXLrows<< sheeetx.row(arow)
    #end
    #
    sheetx.each do  |row|
    aXLrows<< row
     
    end
   return aXLrows 
  end
end
