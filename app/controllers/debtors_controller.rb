class DebtorsController < ApplicationController
  
      respond_to :html,:json
    require 'will_paginate/array'
  before_filter :check_debtors,  :only =>:preindex
  before_filter :require_user, :only => [:index, :preindex ,:show, :display]
  # GET /debtors
  # GET /debtors.json

def check_debtors
      logger.debug "Into check_debtors"
      ##******************
      #  Insert data into debtors table from the feefile
      #
      #
      #  Navigate to urblasdelicias
      #
      #  login to urblasdelicias
      #
      #  navigate to 'http://urblasdelicias.com/module.php?module=config/debtors.php' to retrieve debtor summary
      #  save in page3
      # Go thro page3 to the table then thro each row
      #
      # in each row fetch the 4 values
      #
      # for td[1] check if its an integer (ie reference number)
      #
      # append each column to array sqlA
      #
      # for the balance field regex for the value & ignore the Euro with /[/-\d*\,?\d*\.\d\d/]/
      #
      # move sqlA values into multidimensional array sqlValues[rowindex]  a bit redundant but easier to fault find
      #
      # after reading all the rows, insert the data into the ocmsummaries,
      #  for each balance value remove the thousands comma first
      #
      #     
      #     
      #      
      #
      #      
      
# if there is an debtor_files entry but no entries in debtors table then generate it with insert_table
  exs=Feefile.find_by_sql("select feefile_id  from debtor_files where  feefile_id 
   not in(SELECT feefile_id  FROM debtors group by feefile_id)")
  logger.debug "exs  = #{exs.inspect} \n"
    exs.each do |exf|
    logger.debug "Going to Debtor.insert_table for feefile_id = #{exf}  -- #{exf.feefile_id}"
    Debtor.insert_table(exf.feefile_id)
    Debtor.fetch_ocm()
    Debtor.insert_comparisons()
    end
    #*****************  Now get the debtors summary from the OCM website
#      require 'rubygems'
#require 'mechanize'
#require 'logger'
#logger= Logger.new(STDOUT)  



end

def preindex
  flash[:notice] = "Debtor Extract Completed OK"
    logger.debug " In debtor preindex"
    redirect_to :controller=>"debtors" , :action=>"comparisons"
end

  def index
 index_columns ||= [:ref,:property,:owner,:balance]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 100
    conditions={:page => current_page, :per_page => rows_per_page,  :order=>'ref ASC'}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
#******* need to alter the  order by clause from params as conditions don't seem to get passed
logger.debug(" ****Conditions for debtors--ocmsummaries =  #{conditions.inspect}")
    find_sql ="select ocm.ref,ocm.property,ocm.owner,ocm.balance
    from  ocmsummaries as ocm 
     order by #{conditions[:order]}"  #order by exf.ref'
     
    @ocm= Feefile.paginate_by_sql(find_sql,conditions)
    total_entries=@ocm.total_entries
       respond_with(@ocm) do |format|
      format.json { render :json => @ocm.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
      end
  end

  # GET /debtors/1
  # GET /debtors/1.json
  def show
    @debtor = Debtor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @debtor }
    end
  end


def comparisons
  index_columns ||= [:reference4,:reference2,:property,:owner,:sbalance,:obalance, :indicator]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 100
    conditions={:page => current_page, :per_page => rows_per_page,  :order=>'Indicator ASC, reference2 ASC'}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
#******* need to alter the  order by clause from params as conditions don't seem to get passed
logger.debug(" ****Conditions for debtors--comparisons =  #{conditions.inspect}")
    find_sql ="select comp.reference4,comp.reference2,comp.property,comp.owner,comp.sbalance,comp.obalance, comp.indicator
    from  comparisons as comp 
     order by #{conditions[:order]}"  #order by exf.ref'
     
    @comp= Feefile.paginate_by_sql(find_sql,conditions)
    total_entries=@comp.total_entries
       respond_with(@comp) do |format|
      format.json { render :json => @comp.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
      end
  end
  # GET /debtors/new
  # GET /debtors/new.json
  def new
    @debtor = Debtor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @debtor }
    end
  end

  # GET /debtors/1/edit
  def edit
    @debtor = Debtor.find(params[:id])
  end

  # POST /debtors
  # POST /debtors.json
  def create
    @debtor = Debtor.new(params[:debtor])

    respond_to do |format|
      if @debtor.save
        format.html { redirect_to @debtor, :notice => 'Debtor was successfully created.' }
        format.json { render :json => @debtor, :status => :created, :location => @debtor }
      else
        format.html { render :action => "new" }
        format.json { render :json => @debtor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /debtors/1
  # PUT /debtors/1.json
  def update
    @debtor = Debtor.find(params[:id])

    respond_to do |format|
      if @debtor.update_attributes(params[:debtor])
        format.html { redirect_to @debtor, :notice => 'Debtor was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @debtor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /debtors/1
  # DELETE /debtors/1.json
  def destroy
    @debtor = Debtor.find(params[:id])
    @debtor.destroy

    respond_to do |format|
      format.html { redirect_to debtors_url }
      format.json { head :ok }
    end
  end
  
    def download
      comparisonfilename  = DebtorFile.find(:first).name+"out.csv"
           
      @comparison = Comparison.find(:all)
      # Create a comparison file as a csv file
      keys=["reference4", "reference2", "property", "owner", "sbalance", "obalance", "indicator"]
      directory= "uploads"
      compfilename= File.join(directory,comparisonfilename)
      compfile= File.new(compfilename,"w+")
      
      keys.each{|kk|
           compfile.write("#{kk},") }
      compfile.write("\n")
 
      @comparison.each{|cp|
            keys.each{|kk|
                  compfile.write(  "#{cp.attributes()[kk]},"  ) }
            compfile.write("\n") }
      compfile.close()
      #compfile.write(cp)   cp.attributes().each{ |ky,vl|  compfile.write("#{vl},")}
 
    
 #   send_file( File.join(directory,@feefile.extractfilename), :type =>"application/txt")
  send_file( File.join(directory,comparisonfilename),:type => 'text/csv')
  end
end
