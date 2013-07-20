require 'spec_helper'

describe "field_sets/edit" do
  before(:each) do
    @field_set = assign(:field_set, stub_model(FieldSet,
      :type => "",
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit field_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", field_set_path(@field_set), "post" do
      assert_select "input#field_set_type[name=?]", "field_set[type]"
      assert_select "input#field_set_name[name=?]", "field_set[name]"
      assert_select "input#field_set_description[name=?]", "field_set[description]"
    end
  end
end
