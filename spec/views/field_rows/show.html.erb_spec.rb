require 'spec_helper'

describe "field_rows/show" do
  before(:each) do
    @field_row = assign(:field_row, stub_model(FieldRow,
      :custom_field => nil,
      :field_set => nil,
      :row => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/1/)
  end
end
