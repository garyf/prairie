require "spec_helper"

describe FieldRowsController do
  describe "routing" do

    it "routes to #index" do
      get("/field_rows").should route_to("field_rows#index")
    end

    it "routes to #new" do
      get("/field_rows/new").should route_to("field_rows#new")
    end

    it "routes to #show" do
      get("/field_rows/1").should route_to("field_rows#show", :id => "1")
    end

    it "routes to #edit" do
      get("/field_rows/1/edit").should route_to("field_rows#edit", :id => "1")
    end

    it "routes to #create" do
      post("/field_rows").should route_to("field_rows#create")
    end

    it "routes to #update" do
      put("/field_rows/1").should route_to("field_rows#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/field_rows/1").should route_to("field_rows#destroy", :id => "1")
    end

  end
end
