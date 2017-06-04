# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :extracted_file do
      name "MyString"
      startdate "2011-11-21"
      enddate "2011-11-21"
      feefile nil
    end
end