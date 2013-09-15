require 'spec_helper'

describe "education_levels/show" do
  before(:each) do
    @education_level = assign(:education_level, stub_model(EducationLevel,
      :name => "Name",
      :description => "Description",
      :row => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/1/)
  end
end
