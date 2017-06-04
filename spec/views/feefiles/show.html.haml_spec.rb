require 'spec_helper'

describe "feefiles/show.html.haml" do
  before(:each) do
    @feefile = assign(:feefile, stub_model(Feefile,
      :feefilename => "Feefilename",
      :feefiletitle => "Feefiletitle",
      :feefiletype => "Feefiletype"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Feefilename/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Feefiletitle/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Feefiletype/)
  end
end
