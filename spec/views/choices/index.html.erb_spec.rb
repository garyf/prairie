require 'spec_helper'

describe "choices/index" do
  before(:each) do
    assign(:choices, [
      stub_model(Choice,
        :name => "Name",
        :custom_field => nil,
        :row => 1
      ),
      stub_model(Choice,
        :name => "Name",
        :custom_field => nil,
        :row => 1
      )
    ])
  end

  it "renders a list of choices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
