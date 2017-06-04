class Hash
def self.create(keys, values)
self[*keys.zip(values).flatten]
end
end
def is_numeric?(s)
    !!Float(s) rescue false
end 
class Debtor < ActiveRecord::Base
    belongs_to :feefile

    
def self.insert_table(ffid)
  require 'csv' #require 'fastercsv'
  directory= "uploads"
  keys= ["owner", "reference","property", "coefficient","adate","subject", "fees", "payments" ]
  sqlfields="owner, reference,property, coefficient,adate,subject, fees, payments,feefile_id,created_at,updated_at" 
  #ffid=67
  csvFile= File.join(directory,Feefile.find(ffid).debtorfilename)
  logger.debug " csvFile being used is #{csvFile}"

  #csvFile= "uploads\\MAYORES A 30.01.12.xls-debt.csv" 
  counter=1
    Debtor.transaction do
      File.open(csvFile,'r:iso-8859-1:utf-8') do |tempFile| #File.open(csvFile,"r") do |tempFile|
        while (line=tempFile.gets)
          if counter >5
          vv=CSV.parse_line(line) # vv=FasterCSV.parse_line(line)
            hh=Hash.create(keys,vv).merge({:feefile_id=>"#{ffid}"})
              #        puts hh.inspect
               #       puts Date.strptime(hh["adate"],'%d/%m/%Y')
            hh=hh.merge({ "adate" => Date.strptime(hh["adate"],'%d/%m/%Y').to_s})
          # puts hh.inspect
         # puts " AA #{vv[0]} --- #{vv[1]}"
          # puts hh["reference"]
          sqlvalues=""
          keys.each do |k|
          sqlvalues= sqlvalues+"'#{hh[k]}',"
          end
          sqlvalues= sqlvalues+"#{ffid},NOW(),NOW()"
           logger.debug "INSERTING  into debtors values (#{sqlvalues} )"
           Debtor.connection.exec_insert("insert into debtors (#{sqlfields}) values (#{sqlvalues} )","",[])
          # Debtor.create(hh)
          end
          counter+=1
        end
      end
  end # of Transaction
   Debtor.connection.execute(
    "update debtors d, xrefs x set d.ocmref=x.ocmref where d.reference = x.ocm4digitcode ")

   
    
  #  FasterCSV.foreach(csvFile) do |row|
  #  end
   # Extracted.create(:feefile_id=> ffid )
    
end

def self.fetch_ocm()
Ocmsummary.delete_all()
agent = Mechanize.new   #{|a| a.log = Logger.new(STDERR) }
agent.user_agent_alias  ="Windows IE 9"


 page= agent.get('http://urblasdelicias.com/')
 login_page=page.form_with(:name=>  'loginForm')
  # u='26'
   u='Lyates'
 #  p='wh8Y&ad6Mz'
   p='PEWerW'

   # login_page.UserName  = u # LEY changed 29/5/2017
    login_page.username  = u
    #login_page.Password        = p
    login_page.password        = p
    u = u.downcase
   
    authV = 'w'+Digest::MD5.hexdigest(u)+'x@y'+Digest::MD5.hexdigest(p)+'z'
    hashedpass= Digest::SHA512.hexdigest(p)
    hashedpass2=Digest::SHA512.hexdigest(p)
       logger.debug "hashedpass (#{hashedpass} )"
       login_page.hashedpass =hashedpass 
       login_page.hashedpass2 =hashedpass
       
  #  login_page.authVar=authV  #'w4e732ced3463d06de0ca9a15b6153677x@y846250bbec5bfd6e6264e872c99a1937z'
    
    logger.debug "login page  contents (#{login_page.inspect} )"
    page2=agent.submit(login_page)
##page2=agent.submit(login_page,login_page.buttons.first)
logger.debug "page2 contents (#{page2.inspect} )"
  page3=agent.get('http://urblasdelicias.com/module.php?module=config/debtors.php')

 page3.encoding = 'UTF-8'
 
 
 
   keys= ["ref", "property","owner", "balance" ]
   sqlfields = "ref, property,owner, balance, created_at,updated_at"
sqlA = Array.new
        sqlValues=Array.new
        rowIndex=0
        logger.debug "page3 contents (#{page3.inspect} )"
        page3_html = page3/"html"
        logger.debug "page3 html (#{page3_html.inspect} )"  
        page3_body = page3/"html/body"
        logger.debug "page3 body (#{page3_body.inspect} )"
        page3_table = page3/"html/body/table"
        logger.debug "page3 table (#{page3_table.inner_html} )"
 (page3/"html/body/table/tr").each { |prop|
 logger.debug "page3 table sub (#{prop.inner_html} )"
 }
        
 # (page3/"html/body/table/tr").each { |prop|
  (page3/"html/body/table/tr").each { |prop|
    sqlA.clear
    sqlValues[rowIndex]=[]
    logger.debug "ROW is "+prop.inner_html+"\n"
    
    ab=(prop/"td[1]").inner_html
    logger.debug "AB= "+ab
      if is_numeric?(ab)
        then
        logger.debug "COLUMNS \n"
        
        (prop/"td").each{|col|
         sqlA<< col.inner_html
          logger.debug "#{col.inner_html}"
        #  puts  col.inner_html
        } #of each col
        
        #sqlA[1] contains the Parcela and may contain N° so replace it with No?  using .tr_s!("N°","No")
        #sqlA[3] contains the Euro symbol  extract only the numbers
        a = sqlA[3][/-\d*\,?\d*\.\d\d/]
       logger.debug "A= #{a}"
        sqlA[3] =a

       sqlA.each{ |col|
         sqlValues[rowIndex]<<col
       }
       
      
      end
      rowIndex+=1
  }
  
  ##***** Now input contents of sqlValues 4 entries at a time into table ocmsummaries
  
Ocmsummary.transaction {
  sqlValues.each_index {|sVi| 
   if not (sqlValues[sVi].nil? or sqlValues[sVi][0].nil?)  then
     sqlValueString = ""
     sqlValues[sVi][3].tr!(",","")   #take comma out of balance field 
   logger.debug "sqlValues[#{sVi}] = "
   sqlValues[sVi].each {|sV|  sqlValueString<<"'"<<sV<<"',"
     }
  sqlValueString.chomp!(",")
  sqlValueString
     logger.debug "sqlfields = #{sqlfields}"
     logger.debug "sqlValueString = #{sqlValueString}"
    
Ocmsummary.connection.exec_insert("insert into `ocmsummaries` (#{sqlfields}) values(#{sqlValueString},NOW(),NOW())","",[])
    end
  }
  }   # of transaction

end
def self.insert_comparisons()
  #*******
  # Group by the debtors, join to ocmsummaries and then insert into comparisons
  
  Comparison.delete_all()
 a=Comparison.connection.execute("insert into comparisons (reference4,reference2,owner,property,sbalance,obalance,indicator)
select a.r, a.o ,a.owner, a.property ,-a.balance as sbalance, b.balance as obalance,'OK'  from 
(SELECT d.reference r ,d.ocmref as o, max(d.owner) as owner ,max(d.property) as property , sum(d.fees) -sum(d.payments) as balance
FROM `debtors` d group by d.reference 
) as a
LEFT OUTER JOIN (select o.*, o.ref as r   from ocmsummaries o  ) as b
ON a.o=b.r")
 
 #Now update Indicator Column
 Comparison.connection.execute("update comparisons set indicator = 'Discrepancy' where  (obalance<0 && (sbalance<>obalance))")

  
  end
end
