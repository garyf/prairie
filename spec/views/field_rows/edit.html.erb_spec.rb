require 'spec_helper'

describe "field_rows/edit" do
  before(:each) do
    @field_row = assign(:field_row, stub_model(FieldRow,
      :custom_field => nil,
      :field_set => nil,
      :row => 1
    ))
  end

  it "renders the edit field_row form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", field_row_path(@field_row), "post" do
      assert_select "input#field_row_custom_field[name=?]", "field_row[custom_field]"
      assert_select "input#field_row_field_set[name=?]", "field_row[field_set]"
      assert_select "input#field_row_row[name=?]", "field_row[row]"
    end
  end
end
