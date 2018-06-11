require 'rails_helper'

RSpec.describe "users/new", type: :view do
  it "renders new" do
    render
    expect(rendered).to have_link('Googleアカウントでサインアップ', href: google_auth_path)
  end
end
