require 'spec_helper'

describe "education_levels/index" do
  before(:each) do
    assign(:education_levels, [
      stub_model(EducationLevel,
        :name => "Name",
        :description => "Description",
        :row => 1
      ),
      stub_model(EducationLevel,
        :name => "Name",
        :description => "Description",
        :row => 1
      )
    ])
  end

  it "renders a list of education_levels" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
