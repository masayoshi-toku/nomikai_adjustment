require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  include SessionTestHelper

  describe "#current_user" do
    let(:user) { create(:user) }

    context "ユーザーがログイン済みの場合" do
      subject { current_user }
      before { log_in(user) }

      it { is_expected.to eq user }
    end

    context "ユーザーがログインしていない場合" do
      subject { current_user }

      it { is_expected.to eq nil }
    end
  end
end
