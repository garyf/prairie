require 'spec_helper'

describe "field_rows/index" do
  before(:each) do
    assign(:field_rows, [
      stub_model(FieldRow,
        :custom_field => nil,
        :field_set => nil,
        :row => 1
      ),
      stub_model(FieldRow,
        :custom_field => nil,
        :field_set => nil,
        :row => 1
      )
    ])
  end

  it "renders a list of field_rows" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
