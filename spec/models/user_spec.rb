require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    context "正しい値の時" do
      let(:user) { build(:user) }
      it { expect(user).to be_valid }
    end

    context "名前が空の時" do
      let(:empty_name_user) { build(:user, name: '') }
      it { expect(empty_name_user).to be_invalid }
    end

    context "メールアドレスが空の時" do
      let(:empty_email_user) { build(:user, email: '') }
      it { expect(empty_email_user).to be_invalid }
    end

    context "不正なドメインの時" do
      let(:invalid_email_user) { build(:user, email: 'example@gmail.com') }
      it { expect(invalid_email_user).to be_invalid }
    end

    context "重複したアカウントがある時" do
      let(:user) { create(:user) }
      let(:dup_user) { user.dup }
      it { expect(dup_user).to be_invalid }
    end
  end

  describe "#find_or_new_from" do
    before do
      @user = create(:user)
    end

    context "ユーザーが登録されている場合" do
      it "ユーザーを検索する" do
        user = User.find_or_new_from(email: attributes_for(:user)[:email])
        expect(@user).to eq user
      end
    end

    context "ユーザーが登録されていない場合" do
      it "オブジェクトを生成する" do
        user = User.find_or_new_from(email: 'other_example@mwed.co.jp')
        expect(user).to be_new_record
      end
    end
  end
end
