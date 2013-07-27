require 'spec_helper'

describe "choices/edit" do
  before(:each) do
    @choice = assign(:choice, stub_model(Choice,
      :name => "MyString",
      :custom_field => nil,
      :row => 1
    ))
  end

  it "renders the edit choice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", choice_path(@choice), "post" do
      assert_select "input#choice_name[name=?]", "choice[name]"
      assert_select "input#choice_custom_field[name=?]", "choice[custom_field]"
      assert_select "input#choice_row[name=?]", "choice[row]"
    end
  end
end
