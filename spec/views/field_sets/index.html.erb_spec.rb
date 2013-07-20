require 'spec_helper'

describe "field_sets/index" do
  before(:each) do
    assign(:field_sets, [
      stub_model(FieldSet,
        :type => "Type",
        :name => "Name",
        :description => "Description"
      ),
      stub_model(FieldSet,
        :type => "Type",
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of field_sets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
