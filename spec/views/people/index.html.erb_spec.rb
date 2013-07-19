require 'spec_helper'

describe "people/index" do
  before(:each) do
    assign(:people, [
      stub_model(Person,
        :email => "Email",
        :name_first => "Name First",
        :name_last => "Name Last"
      ),
      stub_model(Person,
        :email => "Email",
        :name_first => "Name First",
        :name_last => "Name Last"
      )
    ])
  end

  it "renders a list of people" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Name First".to_s, :count => 2
    assert_select "tr>td", :text => "Name Last".to_s, :count => 2
  end
end
