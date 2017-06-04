Given /^the following feefiles:$/ do |feefiles| 
  Feefile.create!(feefiles.hashes)
 # puts feefiles.hashes.inspect
  feefiles.hashes.each{ |feefile|
    filen= File.join('ploads',feefile["feefilename"])
                  #   puts " filen = #{filen} \n"
    File.open(filen,"w")
    }
end

When /^I delete the (\d+)(?:st|nd|rd|th) feefile$/ do |pos|
  visit feefiles_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following feefiles:$/ do |expected_feefiles_table|
  expected_feefiles_table.diff!(tableish('table tr', 'td,th'),:missing_col=>false)
end

When /^I show the (\d+)rd feefile$/ do |arg1|

pending
end