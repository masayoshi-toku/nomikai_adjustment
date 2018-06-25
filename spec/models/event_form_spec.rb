require 'rails_helper'

RSpec.describe EventForm, type: :model do
  describe "#create" do
    subject { form.create }
    let(:form) { EventForm.new(attributes.merge({ user: user })) }
    let(:user) { create(:user) }

    context "正しい値の場合" do
      let(:attributes) { { title: "第一回飲み会", event_dates_text: "6/18\r06/19\n06/20\r\n6/21\r\n\r\n6/22\n\n\n6/23\r\r\r\r6/24" } }

      it { is_expected.to be_truthy }
      it { expect { subject }.to change { Event.count }.by(1) }
      it { expect { subject }.to change { EventDate.count }.by(7) }

      context "タイトルの文字数が100文字の場合" do
        let(:attributes) { { title: "これは１０文字です。" * 10, event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { is_expected.to be_truthy }
      end
    end

    context "不正な値の場合" do
      context "タイトルが空の場合" do
        let(:attributes) { { title: "", event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { is_expected.to be_falsey }
      end

      context "ユーザーが不明の場合" do
        before { form.user = nil }
        let(:attributes) { { title: "第一回飲み会", event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { is_expected.to be_falsey }
      end

      context "タイトルの文字数が100文字より多い場合" do
        let(:attributes) { { title: "これは１０文字です。" * 10 + 'あ', event_dates_text: "2018/06/18\r\n2018/06/19\r\n2018/06/20" } }

        it { is_expected.to be_falsey }
      end

      context "日付が入力されていない場合" do
        let(:attributes) { { title: "第一回飲み会", event_dates_text: "" } }

        it { is_expected.to be_falsey }
      end
    end
  end
end
