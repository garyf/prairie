require 'spec_helper'

describe "choices/new" do
  before(:each) do
    assign(:choice, stub_model(Choice,
      :name => "MyString",
      :custom_field => nil,
      :row => 1
    ).as_new_record)
  end

  it "renders new choice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", choices_path, "post" do
      assert_select "input#choice_name[name=?]", "choice[name]"
      assert_select "input#choice_custom_field[name=?]", "choice[custom_field]"
      assert_select "input#choice_row[name=?]", "choice[row]"
    end
  end
end
