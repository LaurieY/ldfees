class Feefile2sController < ApplicationController
    require 'will_paginate/array'
  #  before_filter :require_no_user, :only => [:index, :show, :display]
  before_filter :require_user, :only => [:index, :show, :display]
  # GET /feefiles
  # GET /feefiles.xml
  include FeefilesHelper

def index
    @feefiles = Feefile.paginate( :page=>params[:page]).order('enddate')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feefiles }
    end
  end
  # GET /feefiles/1
  # GET /feefiles/1.xml

  def show
           
      @ps = params
    @feefile = Feefile.find(params[:id])
    @feefile_dates= get_feefile_daterange(@feefile.feefilename)
#   @feefile_rows= get_feefile_rows(@feefile.feefilename)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feefile }
    end
  end
   def display
       logger.debug "**debug *******************entering :display"
           display_columns ||= [:id,:name,:email]
          current_page = params[:page] ? params[:page].to_i : 1
         rows_per_page = params[:rows] ? params[:rows].to_i : 10

         conditions={:page => current_page, :per_page => rows_per_page}
         conditions[:order] = params["sidx"] + " " + params["sord"] unless (params[:sidx].blank? || params[:sord].blank?)
 
     @ps = params 
    @feefile = Feefile.find(params[:id])
    @feefile_dates= get_feefile_daterange(@feefile.feefilename) 
   
    @feefile_rows= get_feefile_rows(@feefile.feefilename).paginate :page=> params[:page] ,:per_page =>20

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feefile }
    end
  end
  # GET /feefiles/1/edit
  def edit

     @feefile = Feefile.find(params[:id])
     @fenddate =    get_feefile_daterange(@feefile.feefilename)[1]
     @feefile.enddate=@fenddate
  end
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
                  @feefile.enddate = Date.strptime(@feefile_dates[1],'%d/%m/%Y')
    respond_to do |format|
      if @feefile.save
        format.html { redirect_to(@feefile, :notice => 'Feefile was successfully created.') }
        format.xml  { render :xml => @feefile, :status => :created, :location => @feefile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feefile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feefiles/1
  # PUT /feefiles/1.xml
  def update
    @feefile = Feefile.find(params[:id])

    respond_to do |format|
      if @feefile.update_attributes(params[:feefile])
        format.html { redirect_to(@feefile, :notice => 'Feefile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feefile.errors, :status => :unprocessable_entity }
      end
    end
  end

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
      
      # find the highest enddate before this file's enddate
      thisends= @feefile.enddate
      @feefile.enddate= (Feefile.find(:last, :order => :enddate,:select=> [:id,:enddate],:conditions=>"enddate <'#{thisends}'").enddate)+1

 #     @startdate = '8/9/2011'
      respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feefile }
      end
  end
  def extracted
      @feefile = Feefile.find(params[:id])
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


 logger.debug(" Command = ruby #{File.join(directory,'run_fees.rb')}")
 #*** now process the extract****
    IO.popen("ruby #{File.join(directory,'run_fees.rb')}"){ |f|
    f.each{|line| @feesinfo << line} }
#  ********* for now assume success so save the output into extract table
@feefile.extractfilename = @feefile.feefilename+"-out.csv"
#@feefile.extractstartdate = params["enddate"]
@feefile.extractstartdate = Date.strptime(params["enddate"],'%d/%m/%Y')
@feefile_dates= get_feefile_daterange(@feefile.feefilename)
    respond_to do |format|
        if @feefile.update_attributes!(@feefile)

      format.html { render :action => "show" } #show.html.erb
      format.xml  { render :xml => @feefile }
           else
        format.html { render :action => "extract" }
        format.xml  { render :xml => @feefile.errors, :status => :unprocessable_entity }
        end
    end
  
  end
  def download
      @feefile = Feefile.find(params[:id])
    directory= "uploads" 
 #   send_file( File.join(directory,@feefile.extractfilename), :type =>"application/txt")
  send_file( File.join(directory,@feefile.extractfilename),:type => 'text/csv')
  end
end
