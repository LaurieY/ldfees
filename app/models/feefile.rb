class Feefile < ActiveRecord::Base
   has_one :extracted_file, :dependent => :destroy
   has_many :extracted, :dependent => :destroy
 
end
