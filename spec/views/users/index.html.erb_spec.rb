require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Mr.example",
        :email => "example@mwed.co.jp"
      ),
      User.create!(
        :name => "Mr.example",
        :email => "example2@mwed.co.jp"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Mr.example", :count => 2
    assert_select "tr>td", :text => "example@mwed.co.jp", :count => 1
    assert_select "tr>td", :text => "example2@mwed.co.jp", :count => 1
  end
end
