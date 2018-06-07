require 'rails_helper'

RSpec.describe "users/new", type: :view do
  it "renders new" do
    render
    expect(rendered).to have_link(href: '/auth/google_oauth2')
  end
end
