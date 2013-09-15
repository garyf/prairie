require "spec_helper"

describe EducationLevelsController do
  describe "routing" do

    it "routes to #index" do
      get("/education_levels").should route_to("education_levels#index")
    end

    it "routes to #new" do
      get("/education_levels/new").should route_to("education_levels#new")
    end

    it "routes to #show" do
      get("/education_levels/1").should route_to("education_levels#show", :id => "1")
    end

    it "routes to #edit" do
      get("/education_levels/1/edit").should route_to("education_levels#edit", :id => "1")
    end

    it "routes to #create" do
      post("/education_levels").should route_to("education_levels#create")
    end

    it "routes to #update" do
      put("/education_levels/1").should route_to("education_levels#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/education_levels/1").should route_to("education_levels#destroy", :id => "1")
    end

  end
end
