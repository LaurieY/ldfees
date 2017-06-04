require "spec_helper"

describe FeefilesController do
  describe "routing" do

    it "routes to #index" do
      get("/feefiles").should route_to("feefiles#index")
    end

    it "routes to #new" do
      get("/feefiles/new").should route_to("feefiles#new")
    end

    it "routes to #show" do
      get("/feefiles/1").should route_to("feefiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/feefiles/1/edit").should route_to("feefiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/feefiles").should route_to("feefiles#create")
    end

    it "routes to #update" do
      put("/feefiles/1").should route_to("feefiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/feefiles/1").should route_to("feefiles#destroy", :id => "1")
    end

  end
end
