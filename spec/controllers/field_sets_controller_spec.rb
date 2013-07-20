require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe FieldSetsController do

  # This should return the minimal set of attributes required to create a valid
  # FieldSet. As you add validations to FieldSet, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "type" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FieldSetsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all field_sets as @field_sets" do
      field_set = FieldSet.create! valid_attributes
      get :index, {}, valid_session
      assigns(:field_sets).should eq([field_set])
    end
  end

  describe "GET show" do
    it "assigns the requested field_set as @field_set" do
      field_set = FieldSet.create! valid_attributes
      get :show, {:id => field_set.to_param}, valid_session
      assigns(:field_set).should eq(field_set)
    end
  end

  describe "GET new" do
    it "assigns a new field_set as @field_set" do
      get :new, {}, valid_session
      assigns(:field_set).should be_a_new(FieldSet)
    end
  end

  describe "GET edit" do
    it "assigns the requested field_set as @field_set" do
      field_set = FieldSet.create! valid_attributes
      get :edit, {:id => field_set.to_param}, valid_session
      assigns(:field_set).should eq(field_set)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new FieldSet" do
        expect {
          post :create, {:field_set => valid_attributes}, valid_session
        }.to change(FieldSet, :count).by(1)
      end

      it "assigns a newly created field_set as @field_set" do
        post :create, {:field_set => valid_attributes}, valid_session
        assigns(:field_set).should be_a(FieldSet)
        assigns(:field_set).should be_persisted
      end

      it "redirects to the created field_set" do
        post :create, {:field_set => valid_attributes}, valid_session
        response.should redirect_to(FieldSet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved field_set as @field_set" do
        # Trigger the behavior that occurs when invalid params are submitted
        FieldSet.any_instance.stub(:save).and_return(false)
        post :create, {:field_set => { "type" => "invalid value" }}, valid_session
        assigns(:field_set).should be_a_new(FieldSet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        FieldSet.any_instance.stub(:save).and_return(false)
        post :create, {:field_set => { "type" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested field_set" do
        field_set = FieldSet.create! valid_attributes
        # Assuming there are no other field_sets in the database, this
        # specifies that the FieldSet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        FieldSet.any_instance.should_receive(:update).with({ "type" => "" })
        put :update, {:id => field_set.to_param, :field_set => { "type" => "" }}, valid_session
      end

      it "assigns the requested field_set as @field_set" do
        field_set = FieldSet.create! valid_attributes
        put :update, {:id => field_set.to_param, :field_set => valid_attributes}, valid_session
        assigns(:field_set).should eq(field_set)
      end

      it "redirects to the field_set" do
        field_set = FieldSet.create! valid_attributes
        put :update, {:id => field_set.to_param, :field_set => valid_attributes}, valid_session
        response.should redirect_to(field_set)
      end
    end

    describe "with invalid params" do
      it "assigns the field_set as @field_set" do
        field_set = FieldSet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FieldSet.any_instance.stub(:save).and_return(false)
        put :update, {:id => field_set.to_param, :field_set => { "type" => "invalid value" }}, valid_session
        assigns(:field_set).should eq(field_set)
      end

      it "re-renders the 'edit' template" do
        field_set = FieldSet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        FieldSet.any_instance.stub(:save).and_return(false)
        put :update, {:id => field_set.to_param, :field_set => { "type" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested field_set" do
      field_set = FieldSet.create! valid_attributes
      expect {
        delete :destroy, {:id => field_set.to_param}, valid_session
      }.to change(FieldSet, :count).by(-1)
    end

    it "redirects to the field_sets list" do
      field_set = FieldSet.create! valid_attributes
      delete :destroy, {:id => field_set.to_param}, valid_session
      response.should redirect_to(field_sets_url)
    end
  end

end