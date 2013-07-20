require 'spec_helper'

describe "field_sets/show" do
  before(:each) do
    @field_set = assign(:field_set, stub_model(FieldSet,
      :type => "Type",
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    rendered.should match(/Name/)
    rendered.should match(/Description/)
  end
end
