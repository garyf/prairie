require 'spec_helper'

describe "education_levels/edit" do
  before(:each) do
    @education_level = assign(:education_level, stub_model(EducationLevel,
      :name => "MyString",
      :description => "MyString",
      :row => 1
    ))
  end

  it "renders the edit education_level form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", education_level_path(@education_level), "post" do
      assert_select "input#education_level_name[name=?]", "education_level[name]"
      assert_select "input#education_level_description[name=?]", "education_level[description]"
      assert_select "input#education_level_row[name=?]", "education_level[row]"
    end
  end
end
