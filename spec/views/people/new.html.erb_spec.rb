require 'spec_helper'

describe "people/new" do
  before(:each) do
    assign(:person, stub_model(Person,
      :email => "MyString",
      :name_first => "MyString",
      :name_last => "MyString"
    ).as_new_record)
  end

  it "renders new person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", people_path, "post" do
      assert_select "input#person_email[name=?]", "person[email]"
      assert_select "input#person_name_first[name=?]", "person[name_first]"
      assert_select "input#person_name_last[name=?]", "person[name_last]"
    end
  end
end
