require 'spec_helper'

describe "education_levels/new" do
  before(:each) do
    assign(:education_level, stub_model(EducationLevel,
      :name => "MyString",
      :description => "MyString",
      :row => 1
    ).as_new_record)
  end

  it "renders new education_level form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", education_levels_path, "post" do
      assert_select "input#education_level_name[name=?]", "education_level[name]"
      assert_select "input#education_level_description[name=?]", "education_level[description]"
      assert_select "input#education_level_row[name=?]", "education_level[row]"
    end
  end
end
