require 'spec_helper'

describe "people/edit" do
  before(:each) do
    @person = assign(:person, stub_model(Person,
      :email => "MyString",
      :name_first => "MyString",
      :name_last => "MyString"
    ))
  end

  it "renders the edit person form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", person_path(@person), "post" do
      assert_select "input#person_email[name=?]", "person[email]"
      assert_select "input#person_name_first[name=?]", "person[name_first]"
      assert_select "input#person_name_last[name=?]", "person[name_last]"
    end
  end
end
