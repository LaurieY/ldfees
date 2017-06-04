class FeefilesController < ApplicationController
        respond_to :html,:json
    require 'will_paginate/array'
  #  before_filter :require_no_user, :only => [:index, :show, :display]
  before_filter :require_user, :only => [:index, :show, :display]
  # GET /feefiles
  # GET /feefiles.xml
  include FeefilesHelper

def old_index

    @feefiles = Feefile.paginate( :page=>params[:page]).order('enddate')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feefiles }
    end
end

def post_data
    ##  if params[:oper] == "del"
    ##Feefile.find(params[:id]).destroy
    ##  render :nothing => true
    ##  end
    message=""
    feefile_params = { :id => params[:id]}

  case params[:oper]

    when 'del'
      Feefile.find(params[:id]).destroy
      message <<  ('del ok')
    else
      message <<  ('unknown action')
    end
        render :json => [true,message] 


end
def index
    index_columns ||= [:feefilename,:startdate,:enddate,:extractfilename,:extractstartdate]
    current_page = params[:page] ? params[:page].to_i : 1
    rows_per_page = params[:rows] ? params[:rows].to_i : 20
    conditions={:page => current_page, :per_page => rows_per_page,  :order=>'startdate ASC, enddate ASC'}
    conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
    
    if params[:_search] == "true"
      conditions[:conditions]=filter_by_conditions(index_columns)
    end
 #@rows_per_page=conditions

@feefile = Feefile.paginate(conditions)


   # @extracted = exfiles.paginate(conditions)
    total_entries=@feefile.total_entries
  #  @thejson =  @feefile.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)
    respond_with(@feefile) do |format|
      format.json { render :json => @feefile.to_jqgrid_json(index_columns, current_page, rows_per_page, total_entries)}  
     end   
end
  # GET /feefiles/1
  # GET /feefiles/1.xml

  def show
           
      @ps = params
    @feefile = Feefile.find(params[:id])
#    @feefile_dates= get_feefile_daterange(@feefile.feefilename)

#   @feefile_rows= get_feefile_rows(@feefile.feefilename)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feefile }
    end
  end
   def display
       logger.debug "**debug *******************entering :display"
     @ps = params 
    @feefile = Feefile.find(params[:id])
 #   @feefile_dates= get_feefile_daterange(@feefile.feefilename) 
   
 @feefile_rows= get_feefile_rows(@feefile.feefilename).paginate :page=> params[:page] ,:per_page =>20
#@feefile_rows= get_feefile_rows(@feefile.feefilename, params[:page] ,20)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feefile }
    end
  end
  # GET /feefiles/1/edit

  # GET /feefiles/new
  # GET /feefiles/new.xml
  def new
    @feefile = Feefile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feefile }
    end
  end



  # POST /feefiles
  # POST /feefiles.xml
  def create
    @feefile = Feefile.new(params[:feefile])
    ffile = params[:feefile][:feefilename]
    @feefile.feefilename= ffile.original_filename
   
    directory= "uploads"
    path =File.join(directory,ffile.original_filename)
    #FileUtils.copy(ffile.local_path, "#{RAILS_ROOT}/public/uploads/#{ffile.original_filename}")
    File.open(path,"wb"){ |f| f.write(ffile.read)}
    @feefile_dates= get_feefile_daterange(@feefile.feefilename) 
         #@feefile.enddate =    get_feefile_daterange(@feefile.feefilename)[1]
                  @feefile.startdate = Date.strptime(@feefile_dates[0],'%d/%m/%Y')
                  @feefile.enddate = Date.strptime(@feefile_dates[1],'%d/%m/%Y')
    respond_to do |format|
      if @feefile.save
        format.html { redirect_to(feefiles_url, :notice => 'Feefile was successfully created.') }
        format.xml  { render :xml => @feefile, :status => :created, :location => @feefile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feefile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feefiles/1
  # PUT /feefiles/1.xml
 

  # DELETE /feefiles/1
  # DELETE /feefiles/1.xml
  def destroy
    @feefile = Feefile.find(params[:id])
    directory= "uploads"
    path =File.join(directory,@feefile.feefilename)
    File.delete(path)
    @feefile.destroy
    

    respond_to do |format|
      format.html { redirect_to(feefiles_url) }
      format.xml  { head :ok }
    end
  end
  def extract
      
      @feefile = Feefile.find(params[:id])  
      # find the highest enddate before this file's enddate, take care if there isn't one
      thisends= @feefile.enddate
        pos_enddate= Feefile.find(:last, :order => :enddate,:select=> [:id,:enddate],:conditions=>"enddate <'#{thisends}'")
      if pos_enddate.nil?
          @feefile.enddate = @feefile.startdate
      else
          @feefile.enddate= pos_enddate.enddate+1
          end

 #     @startdate = '8/9/2011'
      respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feefile }
      end
  end
  def extracted
   @feefile = Feefile.find(params[:id])
   @extracted_file = ExtractedFile.find_by_feefile_id(params[:id])
   #@ps = params
   directory= "uploads"
   config = YAML.load_file(File.join(directory,'fees.yaml'))
   @feesinfo=Array.new
   
   IO.popen("date") { |f| @feesinfo << f.gets }
   # create the yaml file to be used template in template.yaml write out to lib/fees.yaml
   # in the yaml file make the output file == the input filename with -out.csv appended
   
   config["fees"]= File.join(directory,@feefile.feefilename)
   config["output"]= File.join(directory,@feefile.feefilename)+"-out.csv"
   #options= config["options"]
   config["options"] = ["-a", "-c", "-s"]<<params["enddate"]
   logger.debug "config =  #{config.inspect} "
# Now write back out to fees.yaml
    File.open( File.join(directory,'fees.yaml'), 'w' ) do |out|
    YAML.dump( config, out )
        end


    logger.debug(" Command = ruby #{File.join(directory,'run_fees2.0.rb')}")
 #*** now process the extract****
    IO.popen("ruby #{File.join(directory,'run_fees2.0.rb')}"){ |f|
    f.each{|line| @feesinfo << line} }
#  ********* for now assume success so save the output into extract table
    @feefile.extractfilename = @feefile.feefilename+"-out.csv"
    @feefile.extractstartdate = Date.strptime(params["enddate"],'%d/%m/%Y')
        #@feefile_dates= get_feefile_daterange(@feefile.feefilename)
        
        # If ExtractedFile already exists destroy it and dependent extracteds the re-create
     ex=ExtractedFile.find_by_feefile_id(params[:id])
        if ex.nil?   #  Create the extracted_file record if blank
            ex = ExtractedFile.create(:feefile_id=>params[:id],
            :name=>@feefile.extractfilename,
            :enddate=> @feefile.enddate)
        else 
            logger.info " ***********DestroyinfExtractedFile ID #{ex.id}  "
            feefile_id= ex.feefile_id
                ex.destroy
                logger.info " ***********DestroyinExtracteds  with feefile_ID #{feefile_id}  "
                #Extracted.connection.execute "delete from extracteds where feefile_id ={feefile_id}  "
               Extracted.transaction do
               
                Extracted.delete_all("feefile_id=#{feefile_id}")
                end
                # then all the dependednt extracteds (can't do automaticallyas no dependency)
            
             ex = ExtractedFile.create(:feefile_id=>params[:id],
            :name=>@feefile.extractfilename,
            :enddate=> @feefile.enddate)
        end
        logger.debug "************* contents of @feefile = #{@feefile.inspect} "
        ex.startdate=@feefile.extractstartdate
        ex.save
      
    #if @feefile.update_attributes!(@feefile)
     if @feefile.update_attributes!({:extractfilename=>@feefile.extractfilename, :extractstartdate=>@feefile.extractstartdate})
            
    flash[:notice] = "Extract Completed OK"
    
    redirect_to :controller=>"extracteds" , :action=>"index"
    else
    render :action => "extract"
    end

    ##respond_to do |format|
    ##    if @feefile.update_attributes!(@feefile)
    ##   
    ##    format.html { render :action => "index"  } #show.html.erb
    ##  format.xml  { render :xml => @feefile }
    ##       else
    ##    format.html { render :action => "extract" }
    ##    format.xml  { render :xml => @feefile.errors, :status => :unprocessable_entity }
    ##    end
    ##end
  
  end
    def debtor
        #**********
        #
        # called from feefiles index page 'Produce Debtors list '
        #
        # creates the debt-csv file from the selected feefile
        #
        # Empty table debtorfiles and table debtors
        #
        # Inserts data into debtorfiles   (but not debtors?)
        #
        #  Moves focus to debtor#preindex
        #
        #  where it will insert data into table debtors via 'before_filter :check_debtors'
        #
        #
        #
   @feefile = Feefile.find(params[:id])
   @extracted_file = DebtorFile.find_by_feefile_id(params[:id])
   #@ps = params
   directory= "uploads"
   config = YAML.load_file(File.join(directory,'fees.yaml'))
   @feesinfo=Array.new
   
   IO.popen("date") { |f| @feesinfo << f.gets }
   # create the yaml file to be used template in template.yaml write out to lib/fees.yaml
   # in the yaml file make the output file == the input filename with -out.csv appended
   
   config["fees"]= File.join(directory,@feefile.feefilename)
   config["output"]= File.join(directory,@feefile.feefilename)+"-debt.csv"
   #options= config["options"]
   #  config["options"] = ["-a", "-c", "-s"]<<params["enddate"]  # params for standard extract
   config["options"] = [ "-c"]  # params for debtor type  extract
   logger.debug "config =  #{config.inspect} "
# Now write back out to fees.yaml
    File.open( File.join(directory,'fees.yaml'), 'w' ) do |out|
    YAML.dump( config, out )
        end


    logger.debug(" Command = ruby #{File.join(directory,'run_fees2.0.rb')}")
 #*** now process the extract****
    IO.popen("ruby #{File.join(directory,'run_fees2.0.rb')}"){ |f|
    f.each{|line| @feesinfo << line} }
#  ********* for now assume success so save the output into extract table
 
    @feefile.debtorfilename = @feefile.feefilename+"-debt.csv"
	 logger.debug(" assumed debtorfilename #{@feefile.debtorfilename}")
    @feefile.debtorstartdate = @feefile.startdate #Date.strptime(params["startdate"],'%d/%m/%Y')
        #@feefile_dates= get_feefile_daterange(@feefile.feefilename)
        
        # If DebtorFile already exists destroy it and dependent debtors then re-create
        # Actually need to delete all  debtorfile records as I only want to keep one set of debtor records
     
     logger.debug " ***********Destroying all DebtorFile }  "
            #feefile_id= ex.feefile_id
                DebtorFile.delete_all()
                logger.debug " ***********Destroying ALL Debtors    "
                Debtor.transaction do
                        Debtor.delete_all()
                end
     #ex=DebtorFile.find_by_feefile_id(params[:id])
         #  Create the extracted_file record as its  blank
            ex = DebtorFile.create(:feefile_id=>params[:id],
            :name=>@feefile.debtorfilename,
            :enddate=> @feefile.enddate)
       
        logger.debug "************* contents of DebtorFile @ex = #{@ex.inspect} "
        ex.startdate=@feefile.debtorstartdate
        ex.save
      logger.debug "******NOW contents of DebtorFile @ex = #{@ex.inspect} "
    #if @feefile.update_attributes!(@feefile)
     if @feefile.update_attributes!({:debtorfilename=>@feefile.debtorfilename, :debtorstartdate=>@feefile.debtorstartdate})
     logger.debug     "Debtor Extract Completed OK"  
    flash[:notice] = "Debtor Extract Completed OK"
    
    redirect_to :controller=>"debtors" , :action=>"preindex"
    else
    render :action => "debtor2"
    end

    ##respond_to do |format|
    ##    if @feefile.update_attributes!(@feefile)
    ##   
    ##    format.html { render :action => "index"  } #show.html.erb
    ##  format.xml  { render :xml => @feefile }
    ##       else
    ##    format.html { render :action => "extract" }
    ##    format.xml  { render :xml => @feefile.errors, :status => :unprocessable_entity }
    ##    end
    ##end
      end

  def download
      @feefile = Feefile.find(params[:id])
    directory= "uploads"
    ##Create a csv file  (or xls) conatining the comparison data
 #   send_file( File.join(directory,@feefile.extractfilename), :type =>"application/txt")
  send_file( File.join(directory,@feefile.extractfilename),:type => 'text/csv')
  end
end
