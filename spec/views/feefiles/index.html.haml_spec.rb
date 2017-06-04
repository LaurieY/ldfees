require 'spec_helper'

describe "feefiles/index.html.haml" do
  before(:each) do
    assign(:feefiles, [
      stub_model(Feefile,
        :feefilename => "Feefilename",
        :feefiletitle => "Feefiletitle",
        :feefiletype => "Feefiletype"
      ),
      stub_model(Feefile,
        :feefilename => "Feefilename",
        :feefiletitle => "Feefiletitle",
        :feefiletype => "Feefiletype"
      )
    ])
  end

  it "renders a list of feefiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Feefilename".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Feefiletitle".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Feefiletype".to_s, :count => 2
  end
end
