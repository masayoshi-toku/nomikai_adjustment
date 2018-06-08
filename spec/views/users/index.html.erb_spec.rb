require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Name",
        :email => "sth@mwed.co.jp"
      ),
      User.create!(
        :name => "Name",
        :email => "sthagain@mwed.co.jp"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "sth@mwed.co.jp".to_s, :count => 1
    assert_select "tr>td", :text => "sthagain@mwed.co.jp".to_s, :count => 1
  end
end
