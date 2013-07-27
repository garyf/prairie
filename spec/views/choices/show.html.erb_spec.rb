require 'spec_helper'

describe "choices/show" do
  before(:each) do
    @choice = assign(:choice, stub_model(Choice,
      :name => "Name",
      :custom_field => nil,
      :row => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
    rendered.should match(/1/)
  end
end
