require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    before { get :new }
    it { expect(response).to be_success }
  end
end
