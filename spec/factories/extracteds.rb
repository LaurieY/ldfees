# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :extracted do
      owner "MyString"
      reference 1
      property "MyString"
      coefficient "9.99"
      adate "2011-11-22"
      subject "MyString"
      fees "9.99"
      payments "9.99"
      feefile nil
    end
end