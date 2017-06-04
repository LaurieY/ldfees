require 'spec_helper'

describe "feefiles/edit.html.haml" do
  before(:each) do
    @feefile = assign(:feefile, stub_model(Feefile,
      :feefilename => "MyString",
      :feefiletitle => "MyString",
      :feefiletype => "MyString"
    ))
  end

  it "renders the edit feefile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => feefiles_path(@feefile), :method => "post" do
      assert_select "input#feefile_feefilename", :name => "feefile[feefilename]"
      assert_select "input#feefile_feefiletitle", :name => "feefile[feefiletitle]"
      assert_select "input#feefile_feefiletype", :name => "feefile[feefiletype]"
    end
  end
end
