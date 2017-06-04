class ExtractedsController < ApplicationController
    respond_to :html,:json
    require 'will_paginate/array'
  before_filter :check_extracteds,  :only =>:index
  before_filter :require_user, :only => [:index, :show, :display]
 # protected
  
  def post_data
    ##  if params[:oper] == "del"
    ##Feefile.find(params[:id]).destroy
    ##  render :nothing => true
    ##  end
    message=""
    feefile_params = { :id => params[:id]}
var ret = jQuery("#extracteds").jqGrid('getRowData',id);
#logger.debug(" ret= ***********  #{ret.inspect}")
  case params[:oper]

    when 'del'
      Extracted.find(params[:id]).destroy
      message <<  ('del ok')
    else
      message <<  ('unknown action')
    end
        render :json => [true,message] 


end
  def check_extracteds
# if there is an extracted_files entry but no entries in extracteds table then generate if with insert_table
  exs=Feefile.find_by_sql("select feefile_id  from extracted_files where  feefile_id 
   not in(SELECT feefile_id  FROM extracteds group by feefile_id)")
    exs.each do |exf|
    Extracted.insert_table(exf.feefile_id)
    end
  end
  def show
    index_columns ||= [:owner,:reference,:property,:coefficient,:adate,:subject,:fees,:payments]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 25
    conditions={:page => current_page, :per_page => rows_per_page, :conditions=> "feefile_id=#{params[:id]}", :order=>'id ASC'}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
 #@rows_per_page=conditions
#:conditions=> "feefile_id=#{params[:id]}",
#@extracted = Extracted.paginate(conditions)

#    find_sql ="select ex.*, exf.name
#    from  extracted_files as exf , extracteds as ex
#    where exf.feefile_id = ex.feefile_id and exf.feefile_id=#{params[:id]} order by ex.reference, ex.adate"
#@extracted= Extracted.paginate_by_sql(find_sql,conditions)
   @exfilename = Feefile.find_by_id(params[:id])
   @extracted = Extracted.paginate(conditions)
    total_entries=@extracted.total_entries
    @thejson =  @extracted.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)
    respond_with(@extracted) do |format|
      format.json { render :json => @extracted.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
     end
  end
  
  def index
    index_columns ||= [:name,:created_at,:startdate,:enddate, :totalfees,:totalpayments,:totalrows,:feefile_id]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 20
    conditions={:page => current_page, :per_page => rows_per_page,  :order=>'created_at ASC, enddate ASC'}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
#******* need to alter the  order by clause from params as conditions don't seem to get passed
logger.debug(" ****Conditions for extracteds =  #{conditions.inspect}")
    find_sql ="select exf.name as name, exf.created_at, exf.startdate  , exf.enddate , 
     sum(ex.fees) as totalfees, sum(ex.payments) as totalpayments, count(ex.reference) as totalrows,ex.feefile_id 
    from  extracted_files as exf , extracteds as ex
    where exf.feefile_id = ex.feefile_id group by ex.feefile_id order by #{conditions[:order]}"  #order by exf.enddate'
       # exfiles= Feefile.find_by_sql(find_sql)
    @exfiles= Feefile.paginate_by_sql(find_sql,conditions)
    total_entries=@exfiles.total_entries
       respond_with(@exfiles) do |format|
      format.json { render :json => @exfiles.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
      end
  end
  def was_index
  # I want to display only the entries from feefiles where there is an entry for the extracted file,
  # and show the corresponding number of rows in extracted
  # plus start and end dates for the extracted file
 
  
  #exs = Feefile.find(:all, :conditions =>["extractfilename !=  'NULL'"])
  
  
 @exfiles= Feefile.find_by_sql('select exf.name, exf.created_at, exf.startdate  , exf.enddate , 
ex.feefile_id , count(ex.reference) as totalrows, sum(ex.fees) as totalfees, sum(ex.payments) as totalpayments
from  extracted_files as exf , extracteds as ex
where exf.feefile_id = ex.feefile_id group by ex.feefile_id order by exf.enddate')
#aa[0].attributes



  
#exfilez = ExtractedFile.find(:all, :select =>['name', 'created_at', 'startdate', 'enddate', 'feefile_id'])
#@exfiles= Array.new
#    exfilez.each do |exf|
#    #  p exf.inspect
#      p " feefile id = #{exf.feefile_id}"
#    tempsql = "SELECT  feefile_id ,count(reference) as totalrows,
#    sum(fees) as totalfees, sum(payments) as totalpayments from extracteds
#    group by feefile_id having feefile_id = #{exf.feefile_id}"
#    exftemp= ExtractedFile.find_by_sql(tempsql)
# #   p exftemp.inspect
#  #  p exf.attributes
#    p exftemp[0].attributes
#    @exfiles <<exf.attributes.merge(exftemp[0].attributes)
#    # now add the other info into exf, like total fees,m total payments and rowcount
#    end
  end

  def show_old
  # in show I show some analysis of the extracted file and a table with all the contents
  # later add a filter box to display only one property


  @extracted = Extracted.find(:all, :conditions=> "feefile_id=#{params[:id]}").paginate :page=> params[:page] ,:per_page =>20 
  
  end
  def group
  # display the table as in show but grouped by property,
  # just total fees and total payments per property with overall total
  
  end
end
