require "spec_helper"

describe FieldSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/field_sets").should route_to("field_sets#index")
    end

    it "routes to #new" do
      get("/field_sets/new").should route_to("field_sets#new")
    end

    it "routes to #show" do
      get("/field_sets/1").should route_to("field_sets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/field_sets/1/edit").should route_to("field_sets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/field_sets").should route_to("field_sets#create")
    end

    it "routes to #update" do
      put("/field_sets/1").should route_to("field_sets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/field_sets/1").should route_to("field_sets#destroy", :id => "1")
    end

  end
end
