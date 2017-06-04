require 'spec_helper'

describe "feefiles/new.html.haml" do
  before(:each) do
    assign(:feefile, stub_model(Feefile,
      :feefilename => "MyString",
      :feefiletitle => "MyString",
      :feefiletype => "MyString"
    ).as_new_record)
  end

  it "renders new feefile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => feefiles_path, :method => "post" do
      assert_select "input#feefile_feefilename", :name => "feefile[feefilename]"
      assert_select "input#feefile_feefiletitle", :name => "feefile[feefiletitle]"
      assert_select "input#feefile_feefiletype", :name => "feefile[feefiletype]"
    end
  end
end
